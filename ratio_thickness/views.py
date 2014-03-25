from pyramid.view import view_config
import pypes.packet
import stackless

network = {}


@view_config(route_name='component', renderer='json')
def get_component(request):
    name = request.matchdict['name']
    return network[name]


@view_config(route_name='components', renderer='json')
def get_components(request):
    print(request.registry.settings)
    print(request.registry.pipeline)
    p = request.registry.pipeline
    packet = pypes.packet.Packet()
    packet.set("data", "Tom")
    p.send(packet)
    return {}


@view_config(route_name='name', renderer='json')
def get_forever(request):
    print("ZMQ receiver receiving")
    request.registry.zmq_receiver.send_string("get me stuff!")
    value = request.registry.zmq_receiver.recv_pyobj()
    print("ZMQ receiver received", value)
    return value
