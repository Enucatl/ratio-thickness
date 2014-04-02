<%inherit file="application.mako"/>
<h1 id="page-title">Dataset analysis</h1>

<h2>Choose dataset</h2>
<div class="row">
    <div class="col-md-4">
        <input type="hidden" id="select-dataset" style="width:100%" data-placeholder="choose a dataset" />
    </div>
</div>

<h2>Reconstruction</h2>

<div class="row" id="reconstruction-placeholder">
    <div class="col-md-6" id="images">
        <div class="col-md-12" id="abs-image">
            Absorption
        </div>
        <div class="col-md-12" id="df-image">
            Dark field
        </div>
    </div>
    <div class="col-md-6" id="profiles">
        Profiles
    </div>
</div>

<h2>Ratio</h2>

<div class="row" id="ratio-plots">
    <div class="col-md-4" id="ratio-position">
        Log ratio for the rows above
    </div>
    <div class="col-md-4" id="ratio-abs">
        Log ratio as a function of transmission
    </div>
    <div class="col-md-4" id="ratio-df">
        Log ratio as a function of dark field
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
        src="${assetmutator_url('ratio_thickness:static/js/scatter.coffee')}"
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

    <script
        src="${assetmutator_url('ratio_thickness:static/js/select_dataset.coffee')}"
        type="text/javascript">
    </script>

</%block>
