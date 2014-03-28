from pyramid.view import view_config
import pypes.packet

from pypes.plugins.zmq import recv_array


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
    socket = request.registry.sockets[int(port)]
    array = recv_array(socket)
    print("ZMQ receiver received", array)
    return array.tolist()


@view_config(route_name='home', renderer='templates/index.mako')
def get_home(request):
    return {"title": "Home"}


@view_config(route_name='single_dataset',
             renderer='templates/single_dataset.mako')
def get_reconstruction(request):
    return {"title": "Single dataset analysis"}


@view_config(route_name='segmentation', renderer='templates/segmentation.mako')
def get_segmentation(request):
    return {"title": "Segmentation"}


@view_config(route_name='average', renderer='templates/average.mako')
def get_average(request):
    return {"title": "Average"}
