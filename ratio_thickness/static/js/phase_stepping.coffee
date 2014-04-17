jQuery ->

    window.loadreconstruction = (title, filename) ->

        get_request = ->
            request = d3.xhr "/hdf5dataset"
            request.mimeType "application/json"
            request.response (request) ->
                JSON.parse request.responseText
            request

        get_request_object = (datasetname) ->
            request_object = JSON.stringify({
                    file: filename
                    dataset: datasetname
                })     


        #$("#page-title").text("Dataset reconstruction: #{title}")
        factor = 0.618
        #images = [
            #{
                #file: filename
                #dataset: "postprocessing/dpc_reconstruction"
                #placeholder: "#absorption-image"
                #image: d3.chart.image()
            #},
            #{
                #file: filename
                #dataset: "postprocessing/dpc_reconstruction"
                #placeholder: "#dark-field-image"
                #image: d3.chart.image()
                    #.color_value (d) -> d[2]
            #},
            #{
                #file: filename
                #dataset: "postprocessing/dpc_reconstruction"
                #placeholder: "#phase-image"
                #image: d3.chart.image()
                    #.color_value (d) -> d[1]
            #},
            #{
                #file: filename
                #dataset: "postprocessing/visibility"
                #placeholder: "#visibility"
                #image: d3.chart.image()
                    #.color_value (d) -> d
            #},
            #{
                #file: filename
                #dataset: "postprocessing/flat_parameters"
                #placeholder: "#flat-phase"
                #image: d3.chart.image()
                    #.color_value (d) -> d[1]
            #},
            #{
                #file: filename
                #dataset: "postprocessing/flat_parameters"
                #placeholder: "#flat-absorption"
                #image: d3.chart.image()
                    #.color_value (d) -> d[0]
            #},
        #]
        #get_image = (image) ->
            ##request data
            #get_request().post get_request_object(image.dataset), (error, data) ->
                #return console.warn error if error?
                #d3.select image.placeholder
                    #.data [data]
                    #.call image.image

        #images.map get_image

        #get_request().post get_request_object("postprocessing/visibility"), (error, data) ->
            #return console.warn error if error?
            #flattened = data.reduce (a, b) -> a.concat b
            #placeholder = "#visibility-distribution"
            #width = $(placeholder).width()
            #histogram = d3.chart.histogram()
            #histogram
                #.x_scale()
                #.domain [0, 1.2 * d3.max flattened]
                #.nice()
            #histogram
                #.width width
                #.height width * factor
                #.value (d) -> d
                #.x_title "visibility"
                #.y_title "pixels"
            #d3.select placeholder
                #.data [flattened]
                #.call histogram

        #request phase stepping curves
        phase_stepping_data = {}
        phase_stepping_plot = d3.chart.phase_stepping()
        get_request().post get_request_object("postprocessing/phase_stepping_curves"), (error, data) ->
            return console.warn error if error?
            flattened = data.reduce (a, b) -> a.concat b
            placeholder = "#phase-stepping-curves"
            width = $(placeholder).width()
            phase_stepping_data.phase_stepping_curves = {
                name: "phase_stepping_curves"
                values: data
            }
            get_request().post get_request_object("postprocessing/flat_parameters"), (error, flatpars) ->
                return console.warn error if error?
                phase_stepping_data.flat_parameters = {
                    name: "flat"
                    values: flatpars
                }
                get_request().post get_request_object("postprocessing/dpc_reconstruction"), (error, dpcreco) ->
                    return console.warn error if error?
                    phase_stepping_data.sample_parameters = {
                        name: "sample"
                        values: dpcreco
                    }
                    phase_stepping_plot.data phase_stepping_data
                    phase_stepping_plot
                        .width $(placeholder).width()
                        .height factor * $(placeholder).width()
                    d3.select placeholder
                        .data [{col: 0, row: 0}]
                        .call phase_stepping_plot


    $("#select-dataset").change ->
        file = $(this).val()
        name = $(".select2-chosen").text()
        window.loadreconstruction(name, file)

    jQuery.ajax {
        url: "/datasets"
        dataType: "json"
        success: (data, s, xhr) ->
            data = data[4]
            window.loadreconstruction(data.name, data.file)
    }
