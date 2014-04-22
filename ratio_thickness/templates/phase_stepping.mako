<%inherit file="application.mako"/>
<h1 id="page-title">Dataset reconstruction</h1>
<div class="row">
    <div class="col-md-12">
        <p>
            Phase stepping curve reconstruction.
        </p>

    </div>
</div>

<h2>Reconstruction</h2>

<div class="row">
</div>

<div class="row">
    <div class="col-md-6" id="absorption-image">
        Absorption
    </div>
    <div class="col-md-6" id="phase-stepping-curves">
        Phase stepping curves
    </div>
</div>

<div class="row">
    <div class="col-md-6" id="dark-field-image">
        Dark field
    </div>
    <div class="col-md-6" id="flat-absorption">
        Flat absorption
    </div>
</div>

<div class="row">
    <div class="col-md-6" id="phase-image">
        Differential phase
    </div>
    <div class="col-md-6" id="flat-phase">
        Flat differential phase
    </div>
</div>

<div class="row">
    <div class="col-md-6" id="visibility">
        Visibility map
    </div>
    <div class="col-md-6" id="visibility-distribution">
        Visibility distribution
    </div>
</div>

<div class="row">
    <div class="col-md-6" id="chi-square">
        Chi square
    </div>
    <div class="col-md-6" id="chi-square-distribution">
        Chi square distribution
    </div>
</div>

<h2>Change dataset</h2>
<div class="row">
    <div class="col-md-4">
        <input type="hidden" id="select-dataset" style="width:100%"
        data-placeholder="Choose dataset here..." />
    </div>
</div>

<div class="row">
    <div class="col-md-4">
        <p><a href="/aggregated" class="btn btn-primary btn-lg" role="button">
                Continue with the aggregated results &raquo;</a></p>
    </div>
</div>

<%block name="extra_js">

    <script
        src="${assetmutator_url('ratio_thickness:static/js/select_dataset.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/d3.scatter/scatter.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/d3.image/image.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/d3.histogram/histogram.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="/static/js/d3.colorbar/colorbar.js"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/phase_stepping_curves_plot.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/phase_stepping.coffee')}"
        type="text/javascript">
    </script>

</%block>
