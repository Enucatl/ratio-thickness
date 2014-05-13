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
    <div class="col-md-6">
        <p>
            Absorption
        </p>
        <div id="absorption-image">
        </div>
    </div>
    <div class="col-md-6">
        <p>
            Phase stepping curves
        </p>
        <div id="phase-stepping-curves">
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <p>
            Dark field
        </p>
        <div id="dark-field-image">
        </div>
    </div>
    <div class="col-md-6">
        <p>
            Differential phase
        </p>
        <div id="phase-image">
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <p>
            Visibility map
        </p>
        <div id="visibility">
        </div>
    </div>
    <div class="col-md-6">
        <p>
            Visibility distribution
        </p>
        <div id="visibility-distribution">
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <p>
            Normalized chi square
        </p>
        <div id="chi-square">
        </div>
    </div>
    <div class="col-md-6">
        <p>
            Normalized chi square distribution
        </p>
        <div id="chi-square-distribution">
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <p>
            Flat differential phase
        </p>
        <div id="flat-phase">
        </div>
    </div>
    <div class="col-md-6">
        <p>
            Flat absorption
        </p>
        <div id="flat-absorption">
        </div>
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
