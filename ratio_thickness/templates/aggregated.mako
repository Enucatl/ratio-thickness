<%inherit file="application.mako"/>
<h1 id="page-title">Aggregated results</h1>

<h2>Choose datasets</h2>
<div class="row">
    <div class="col-md-4">
        <input type="hidden" id="select-dataset" style="width:100%" data-placeholder="choose a dataset" />
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
