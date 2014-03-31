<%inherit file="application.mako"/>
<h1>Single dataset data analysis</h1>

<h2>Reconstruction</h2>

<div class="row" id="reconstruction-placeholder">
    <div class="col-md-6" id="abs-reconstruction">
        Absorption
    </div>
    <div class="col-md-6" id="df-reconstruction">
        Dark-field
    </div>
</div>

<div class="row" id="reconstruction-profiles-placeholder">
    <div class="col-md-6" id="abs-reconstruction-profile">
        Absorption profile
    </div>
    <div class="col-md-6" id="df-reconstruction-profile">
        Dark-field profile
    </div>
</div>

<h2>Segmentation</h2>

<div class="row" id="segmentation-mask-placeholder">
    <div class="col-md-6" id="abs-segmentation-mask">
        Absorption mask
    </div>
    <div class="col-md-6" id="abs-segmentation-mask-profile">
        Absorption mask profile
    </div>
</div>

<h2>Ratio - angle</h2>

<div class="row" id="ratio-plot-placeholder">
    <div class="col-md-6" id="ratio-image">
        Ratio image
    </div>
    <div class="col-md-6" id="ratio-plot">
        Ratio plot
    </div>
</div>

<p><a class="btn btn-primary btn-lg" role="button">
        Continue with the segmentation &raquo;</a></p>

<%block name="extra_js">
    <script
        src="${assetmutator_url('ratio_thickness:static/js/profile.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/image.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/single_dataset.coffee')}"
        type="text/javascript">
    </script>

    <script type="text/javascript">
        $(document).ready(function() {
            var filename = "ratio_thickness/static/data/S00918_S00957.hdf5"
            var unused = [40004, 40005, 40006]
            for (item in unused) {
                d3.json("/pipelineoutput/" + unused[item], function(error, json) {
                    if (error) {
                        console.warn(error);
                    }
                });
            }
            var images = window.loadimages(filename);
        });
    </script>
</%block>
