<%inherit file="application.mako"/>
<h1 id="page-title">Aggregated results</h1>

<h2>Controls</h2>
<div class="row">
    <div class="col-md-4" id="slider">
        Slide to change the maximum on the y scale
    </div>
</div>
<div class="row">
    <div class="col-md-4" id="color-slider">
        Slide to change the color scale
    </div>
</div>

<h2>Plot</h2>
<div class="row">
    <div class="col-md-6" id="ratio-abs">
        Log ratio as a function of transmission
    </div>
    <div class="col-md-6" id="ratio-df">
        Log ratio as a function of dark field
    </div>
</div>

<div class="row">
    <div class="col-md-6" id="transmission-df">
        Dark-field as a function of transmission
    </div>
    <div class="col-md-6">
    </div>
</div>

<h2>Description</h2>
<div class="row">
    <div class="col-md-12">
        <p>
            The averages for different thicknesses shown in the single
            dataset analysis are collected here.
        </p>
        <p>
            The log ratio is plotted as a function of transmission and dark
            field.
        </p>
    </div>
</div>

<%block name="extra_js">

    <script
        src="${assetmutator_url('ratio_thickness:static/js/d3.scatter/scatter.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/d3.slider/slider.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/aggregated.coffee')}"
        type="text/javascript">
    </script>

</%block>
