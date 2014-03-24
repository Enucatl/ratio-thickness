from pyramid.config import Configurator


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('component', '/components/{name}')
    config.add_route('components', '/components')
    config.add_route('forever', '/forever')
    config.scan()
    config.include("ratio_thickness.basic_pipeline.include_network")
    config.include("ratio_thickness.loop_forever.include_forever")
    return config.make_wsgi_app()
