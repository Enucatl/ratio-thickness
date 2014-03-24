from pyramid.view import view_config
import pypes.packet

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


@view_config(route_name='forever', renderer='json')
def get_forever(request):
    request.registry.forever()
    return {}
