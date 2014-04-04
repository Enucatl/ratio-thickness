<%inherit file="application.mako"/>
<h1 id="page-title">Dataset analysis</h1>
<div class="row">
    <div class="col-md-12">
        <p>
            Reloading the page or changing the dataset might take a few seconds, since the analysis
            is done online each time.
        </p>
        <p>
            Each dataset is an image of a block of some material taken under
            different rotation angles so that data can be acquired quickly
            with the X-rays going through different thicknesses.
        </p>

    </div>
</div>
<div class="row">
    <div class="col-md-8 col-md-offset-2">
        <p id="dataset-table">
        </p>
    </div>
</div>

<h2>Reconstruction</h2>

<div class="row">
    <p>
        Scan data: 9 phase steps, 5 seconds exposure per step, flats
        taken every 5 lines.
    </p>
    <p>
        The absorption and dark field data, shown below, are reconstructed
        with the usual FFT method. The image is segmented so that the region
        with the most absorption is selected. More in detail, the minimum
        value in the profile is selected, and then values up to 10% higher
        than the minimum are kept. This corresponds to the central section
        of the block in each view. The segmented region is highlighted in
        yellow in the profile below, where the corresponding absorption
        (blue) and
        dark field (orange) signals are also shown.
    </p>
    <p>
        The log ratio is calculated as:
        $$\frac{\log(\text{absorption})}{\log(\text{dark field})}$$
    </p>
    <p>

    </p>
</div>

<div class="row">
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
        src="${assetmutator_url('ratio_thickness:static/js/table.coffee')}"
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
