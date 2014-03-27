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

<div class="row" id="segmentation-sobel-placeholder">
    <div class="col-md-6" id="abs-segmentation-sobel">
        Absorption sobel
    </div>
    <div class="col-md-6" id="df-segmentation-sobel">
        Dark-field sobel
    </div>
</div>

<div class="row" id="segmentation-mask-placeholder">
    <div class="col-md-6" id="abs-segmentation-mask">
        Absorption mask
    </div>
    <div class="col-md-6" id="df-segmentation-mask">
        Dark-field mask
    </div>
</div>

<h2>Ratio - angle</h2>

<div class="row" id="ratio-plot-placeholder">
    <div class="col-md-12" id="ratio-plot">
        Ratio plot
    </div>
</div>

<p><a class="btn btn-primary btn-lg" role="button">
        Continue with the segmentation &raquo;</a></p>

<%block name="extra_js">
    <script
        src="${assetmutator_url('ratio_thickness:static/js/image.coffee')}"
        type="text/javascript">
    </script>
    <script
        src="${assetmutator_url('ratio_thickness:static/js/single_dataset.coffee')}"
        type="text/javascript">
    </script>
</%block>
