<%inherit file="application.mako"/>
<h1>Single dataset data analysis</h1>

<h2>Reconstruction</h2>

<div class="row" id="reconstruction-placeholder">
    <div class="col-md-6" id="abs-image">
        Absorption
    </div>
    <div class="col-md-6" id="df-image">
        Dark field
    </div>
</div>

<div class="row" id="reconstruction-profiles-placeholder">
    <div class="col-md-12" id="profiles">
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

    <script type="text/javascript">
        $(document).ready(function() {
            var filename = "ratio_thickness/static/data/S00918_S00957.hdf5"
            window.loadimages(filename);
        });
    </script>
</%block>
