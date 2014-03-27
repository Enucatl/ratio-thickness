jQuery ->
    jQuery.ajax {
        url: "/pipeline"
        type: "POST"
        contentType: "application/json"
        dataType: "json"
        data: {
            filename: "/static/data/S00918_S00957.hdf5"
        }
    }
    width = $("#abs-reconstruction").width()
    absorption_image = d3.chart.image()
    absorption_image.width width

    d3.json "/pipelineoutput/40000", (error, json) ->
        return console.warn error if error?
        console.log "json", json
        absorption_image.data(json)
        absorption_image.update()
