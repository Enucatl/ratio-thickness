from pyramid.view import view_config
import pypes.packet


@view_config(route_name='pipeline', renderer='json')
def start_pipeline(request):
    p = request.registry.pipeline
    packet = pypes.packet.Packet()
    packet.set("file_name", request.matchdict["file_name"])
    p.send(packet)
    return {}


@view_config(route_name='pipelineoutput', renderer='json')
def get_output(request):
    port = request.matchdict["port"]
    socket = request.registry.sockets[int(port)]
    socket.send_string("request")
    packet = socket.recv_pyobj()
    print("ZMQ receiver received", packet)
    return packet


@view_config(route_name='home', renderer='templates/index.mako')
def get_home(request):
    return {"title": "Home"}


@view_config(route_name='reconstruction',
             renderer='templates/reconstruction.mako')
def get_reconstruction(request):
    return {"title": "Reconstruction"}


@view_config(route_name='segmentation', renderer='templates/segmentation.mako')
def get_segmentation(request):
    return {"title": "Segmentation"}


@view_config(route_name='average', renderer='templates/average.mako')
def get_average(request):
    return {"title": "Average"}
