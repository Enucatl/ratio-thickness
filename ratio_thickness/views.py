from pyramid.view import view_config
import pypes.packet
import zmq


@view_config(route_name='datasets', renderer='json')
def get_datasets(request):
    datasets = [
        {
            "name": "PMMA",
            "file": "ratio_thickness/static/data/S00638_S00677.hdf5",
            "a (mm)": 50,
            "b (mm)": 6.3,
            "simulated": False,
        },
        {
            "name": "Plexiglass",
            "file": "ratio_thickness/static/data/S00678_S00717.hdf5",
            "a (mm)": 50,
            "b (mm)": 9.40,
            "simulated": False,
        },
        {
            "name": "Aluminium",
            "file": "ratio_thickness/static/data/S00718_S00757.hdf5",
            "a (mm)": 30.50,
            "b (mm)": 1,
            "simulated": False,
        },
        {
            "name": "Polystyrene",
            "file": "ratio_thickness/static/data/S00758_S00797.hdf5",
            "a (mm)": 62,
            "b (mm)": 20,
            "simulated": False,
        },
        {
            "name": "Carbon fibers",
            "file": "ratio_thickness/static/data/S00918_S00957.hdf5",
            "a (mm)": 49.35,
            "b (mm)": 4.1,
            "simulated": False,
        },
        {
            "name": "Sim. Ag",
            "file": "ratio_thickness/static/sim_data/Ag.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Al",
            "file": "ratio_thickness/static/sim_data/Al.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Au",
            "file": "ratio_thickness/static/sim_data/Au.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. C",
            "file": "ratio_thickness/static/sim_data/C.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Cu",
            "file": "ratio_thickness/static/sim_data/Cu.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Fe",
            "file": "ratio_thickness/static/sim_data/Fe.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Si",
            "file": "ratio_thickness/static/sim_data/Si.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
    ]
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
    for dataset in request.json_body:
        packet = pypes.packet.Packet()
        packet.set("file_name", dataset["file"])
        request.registry.pipeline.send(packet)
        unused_socket.recv_json()
        array = socket.recv_json()
        averages.append({
            "name": dataset["name"],
            "simulated": dataset["simulated"],
            "values": array
        })
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
