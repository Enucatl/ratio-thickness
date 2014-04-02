from pyramid.view import view_config
import pypes.packet
import zmq
import os


@view_config(route_name='datasets', renderer='json')
def get_datasets(request):
    folder = "ratio_thickness/static/data/"
    datasets = [
        {
            "name": "PMMA",
            "file": "S00638_S00677.hdf5",
            "a (mm)": 50,
            "b (mm)": 6.3,
        },
        {
            "name": "Plexiglass",
            "file": "S00678_S00717.hdf5",
            "a (mm)": 50,
            "b (mm)": 9.40,
        },
        {
            "name": "Aluminium",
            "file": "S00718_S00757.hdf5",
            "a (mm)": 30.50,
            "b (mm)": 1,
        },
        {
            "name": "Polystyrene",
            "file": "S00758_S00797.hdf5",
            "a (mm)": 62,
            "b (mm)": 20,
        },
        {
            "name": "Carbon fibers",
            "file": "S00918_S00957.hdf5",
            "a (mm)": 49.35,
            "b (mm)": 4.1,
        },
    ]
    for dataset in datasets:
        dataset["file"] = os.path.join(
            folder, dataset["file"])
    return datasets


@view_config(route_name='pipeline', renderer='json')
def start_pipeline(request):
    json = request.json_body
    packet = pypes.packet.Packet()
    packet.set("file_name", json["filename"])
    request.registry.pipeline.send(packet)
    return "pipeline started with {0[filename]}".format(json)


@view_config(route_name='pipelineoutput', renderer='json')
def get_output(request):
    port = request.matchdict["port"]
    context = zmq.Context()
    socket = context.socket(zmq.PULL)
    socket.connect("tcp://127.0.0.1:{0}".format(port))
    array = socket.recv_json()
    socket.close()
    return array


@view_config(route_name='aggregatedoutput', renderer='json')
def get_aggregated_output(request):
    averages = []
    context = zmq.Context()
    unused_port = 40000
    port = 40001
    unused_socket = context.socket(zmq.PULL)
    socket = context.socket(zmq.PULL)
    unused_socket.connect("tcp://127.0.0.1:{0}".format(unused_port))
    socket.connect("tcp://127.0.0.1:{0}".format(port))
    for name, filename in request.json_body["files"]:
        packet = pypes.packet.Packet()
        packet.set("file_name", filename)
        request.registry.pipeline.send(packet)
        unused_socket.recv_json()
        array = socket.recv_json()
        averages.extend({
            "name": name,
            "abs": array[0][i],
            "df": array[1][i],
            "ratio": array[2][i],
        } for i in range(array.shape[1]))
    print(averages)
    unused_socket.close()
    socket.close()
    return averages


@view_config(route_name='home', renderer='templates/index.mako')
def get_home(request):
    return {"title": "Home"}


@view_config(route_name='single_dataset',
             renderer='templates/single_dataset.mako')
def get_reconstruction(request):
    return {"title": "Single dataset analysis"}


@view_config(route_name='aggregated', renderer='templates/aggregated.mako')
def get_segmentation(request):
    return {"title": "Aggregated results"}
