from pyramid.config import Configurator


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.assign_assetmutator('coffee', 'coffee -c -p', 'js')
    config.assign_assetmutator('less', 'lessc', 'css')
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('hdf5dataset', '/hdf5dataset')
    config.add_route('phase_stepping', '/phase_stepping')
    config.add_route('normalizedchisquare', '/normalizedchisquare')
    config.add_route('datasets', '/datasets')
    config.add_route('pipelineoutput', '/pipelineoutput/{port}')
    config.add_route('pipeline', '/pipeline')
    config.add_route('single_dataset', '/single_dataset')
    config.add_route('aggregated', '/aggregated')
    config.add_route('aggregatedoutput', '/aggregatedoutput')
    config.scan()
    config.include("ratio_thickness.pipeline.include_pipeline")
    return config.make_wsgi_app()
