from pyramid.view import view_config

network = {}

@view_config(route_name='component', renderer='json')
def get_component(request):
    name = request.matchdict['name']
    return network[name]


@view_config(route_name='components', renderer='json')
def get_components(request):
    name = request.matchdict['name']
    return network


