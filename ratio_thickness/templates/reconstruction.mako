<%inherit file="application.mako"/>
<h1>Reconstruction</h1>
<p>The reconstruction page</p>
<div class="row" id="reconstruction-placeholder">
    <div class="col-md-6" id="abs-reconstruction">
        Absorption
    </div>
    <div class="col-md-6" id="df-reconstruction">
        Dark-field
    </div>
</div>
<div class="row" id="reconstruction-placeholder">
    <div class="col-md-6" id="abs-reconstruction">
        Absorption profile
    </div>
    <div class="col-md-6" id="df-reconstruction">
        Dark-field profile
    </div>
</div>
<p><a class="btn btn-primary btn-lg" role="button">
        Continue with the segmentation &raquo;</a></p>

<%block name="extra_js">
    <script
        src="${assetmutator_url('ratio_thickness:static/js/reconstruction.js.coffee')}"
        type="text/javascript">
    </script>
</%block>
