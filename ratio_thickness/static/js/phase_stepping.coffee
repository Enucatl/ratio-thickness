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


        $("#page-title").text("Dataset reconstruction: #{title}")
        factor = 0.618
        images = [
            {
                file: filename
                dataset: "postprocessing/dpc_reconstruction"
                placeholder: "#absorption-image"
                image: d3.chart.image()
                colorbar: Colorbar()
            },
            {
                file: filename
                dataset: "postprocessing/dpc_reconstruction"
                placeholder: "#dark-field-image"
                image: d3.chart.image()
                    .color_value (d) -> d[2]
                colorbar: Colorbar()
            },
            {
                file: filename
                dataset: "postprocessing/dpc_reconstruction"
                placeholder: "#phase-image"
                image: d3.chart.image()
                    .color_value (d) -> d[1]
                colorbar: Colorbar()
            },
            {
                file: filename
                dataset: "postprocessing/visibility"
                placeholder: "#visibility"
                image: d3.chart.image()
                    .color_value (d) -> d
                colorbar: Colorbar()
            },
            {
                file: filename
                dataset: "postprocessing/flat_parameters"
                placeholder: "#flat-phase"
                image: d3.chart.image()
                    .color_value (d) -> d[1]
                colorbar: Colorbar()
            },
            {
                file: filename
                dataset: "postprocessing/flat_parameters"
                placeholder: "#flat-absorption"
                image: d3.chart.image()
                    .color_value (d) -> d[0]
                colorbar: Colorbar()
            },
        ]

        request = d3.xhr "/normalizedchisquare"
        request.mimeType "application/json"
        request.response (request) ->
            JSON.parse request.responseText
        request
        request_object = JSON.stringify({
                file: filename
            })     
        request.post request_object, (error, data) ->
            return console.warn error if error?
            chi_square = d3.chart.image()
                .color_value (d) -> d
            chi_square_colorbar = Colorbar()
            placeholder = "#chi-square"
            d3.select placeholder
                .data [data]
                .call chi_square
            chi_square_colorbar
                .scale chi_square.color()
                .margin chi_square.margin()
                .barlength chi_square.height()
                .thickness 10
                .origin {
                    x: chi_square.width() + chi_square.margin().left + chi_square.margin().right
                    y: chi_square.margin().top
                }
                .image_thickness chi_square.height() 
                .image_length chi_square.width() 
            d3.select placeholder
                .call chi_square_colorbar

            chi_square.on "line_over", (line) ->
                d3.select "#phase-stepping-curves"
                    .data [line]
                    .call phase_stepping_plot

            flattened = data.reduce (a, b) -> a.concat b
            placeholder = "#chi-square-distribution"
            width = $(placeholder).width()
            histogram = d3.chart.histogram()
            histogram
                .x_scale()
                .domain [0, d3.max(flattened)]
                .nice()
            histogram
                .margin {top: 20, right: 20, bottom: 20, left: 50}
                .n_bins 50
                .width width
                .height width * factor
                .value (d) -> d
                .x_title "normalized χ²"
                .y_title "pixels"
            d3.select placeholder
                .data [flattened]
                .call histogram

            $(placeholder).height(width * factor)

        get_request().post get_request_object("postprocessing/visibility"), (error, data) ->
            return console.warn error if error?
            flattened = data.reduce (a, b) -> a.concat b
            placeholder = "#visibility-distribution"
            width = $(placeholder).width()
            histogram = d3.chart.histogram()
            histogram
                .x_scale()
                .domain [0, 1.2 * d3.max flattened]
                .nice()
            histogram
                .margin {top: 20, right: 20, bottom: 20, left: 50}
                .n_bins 50
                .width width
                .height width * factor
                .value (d) -> d
                .x_title "visibility"
                .y_title "pixels"
            d3.select placeholder
                .data [flattened]
                .call histogram

            $(placeholder).height width * factor

        #request phase stepping curves
        phase_stepping_data = {}
        phase_stepping_plot = d3.chart.phase_stepping()
        get_request().post get_request_object("postprocessing/phase_stepping_curves"), (error, data) ->
            return console.warn error if error?
            flattened = data.reduce (a, b) -> a.concat b
            placeholder = "#phase-stepping-curves"
            width = $(placeholder).width()
            $(placeholder).height(width * factor)
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
                        .x_title "phase stepping point"
                        .y_title "detector counts"
                    d3.select placeholder
                        .data [{col: 150, row: 10}]
                        .call phase_stepping_plot

        get_image = (image) ->
            #request data
            get_request().post get_request_object(image.dataset), (error, data) ->
                return console.warn error if error?
                d3.select image.placeholder
                    .data [data]
                    .call image.image

                $(image.placeholder).height(image.image.height() + image.image.margin().top + image.image.margin().bottom)

                image.colorbar
                    .scale image.image.color()
                    .origin {
                        x: image.image.margin().left
                        y: image.image.margin().top + image.image.height()
                    }
                    .margin image.image.margin()
                    .barlength image.image.width()
                    .thickness 10
                    .image_thickness image.image.height()
                    .image_length image.image.width()
                    .orient "horizontal"

                d3.select image.placeholder
                    .call image.colorbar

                image.image.on "line_over", (line) ->
                    d3.select "#phase-stepping-curves"
                        .data [line]
                        .call phase_stepping_plot

        images.map get_image

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
