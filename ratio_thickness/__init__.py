from pyramid.config import Configurator


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.assign_assetmutator('coffee', 'coffee -c -p', 'js')
    config.assign_assetmutator('less', 'lessc', 'css')
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('pipelineoutput', '/pipelineoutput/{port}')
    config.add_route('pipeline', '/components')
    config.add_route('reconstruction', '/reconstruction')
    config.add_route('segmentation', '/segmentation')
    config.add_route('average', '/average')
    config.scan()
    config.include("ratio_thickness.pipeline.include_pipeline")
    return config.make_wsgi_app()
