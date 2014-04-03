<%inherit file="application.mako"/>
<h1 id="page-title">Aggregated results</h1>

<h2>Plot</h2>

<div class="row">
    <div class="col-md-6" id="ratio-abs">
        Log ratio as a function of transmission
    </div>
    <div class="col-md-6" id="ratio-df">
        Log ratio as a function of dark field
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
        src="${assetmutator_url('ratio_thickness:static/js/scatter.coffee')}"
        type="text/javascript">
    </script>

    <script
        src="${assetmutator_url('ratio_thickness:static/js/aggregated.coffee')}"
        type="text/javascript">
    </script>

</%block>
