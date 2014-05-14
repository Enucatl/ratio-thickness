jQuery ->

    window.loadreconstruction = (title, filename) ->

        get_request = (url) ->
            request = d3.xhr url
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
                url: "/hdf5dataset"
                file: filename
                dataset: "postprocessing/dpc_reconstruction"
                placeholder: "#absorption-image"
                image: d3.chart.image()
                colorbar: Colorbar()
                histogram: false
                title: "transmission"
            },
            {
                url: "/hdf5dataset"
                file: filename
                dataset: "postprocessing/dpc_reconstruction"
                placeholder: "#dark-field-image"
                image: d3.chart.image()
                    .color_value (d) -> d[2]
                colorbar: Colorbar()
                histogram: false
                title: "dark field"
            },
            {
                url: "/hdf5dataset"
                file: filename
                dataset: "postprocessing/dpc_reconstruction"
                placeholder: "#phase-image"
                image: d3.chart.image()
                    .color_value (d) -> d[1]
                colorbar: Colorbar()
                histogram: false
                title: "phase"
            },
            {
                url: "/hdf5dataset"
                file: filename
                dataset: "postprocessing/visibility"
                placeholder: "#visibility"
                image: d3.chart.image()
                    .color_value (d) -> d
                colorbar: Colorbar()
                histogram: false
                title: "visibility"
            },
            {
                url: "/hdf5dataset"
                file: filename
                dataset: "postprocessing/flat_parameters"
                placeholder: "#flat-phase"
                image: d3.chart.image()
                    .color_value (d) -> d[1]
                colorbar: Colorbar()
                histogram: false
                title: "flat phase"
            },
            {
                url: "/hdf5dataset"
                file: filename
                dataset: "postprocessing/flat_parameters"
                placeholder: "#flat-absorption"
                image: d3.chart.image()
                    .color_value (d) -> d[0]
                colorbar: Colorbar()
                histogram: false
                title: "flat transmission"
            },
            {
                url: "/normalizedchisquare"
                file: filename
                dataset: ""
                placeholder: "#chi-square"
                image: d3.chart.image()
                    .color_value (d) -> d
                colorbar: Colorbar()
                histogram: d3.chart.histogram()
                title: "normalized χ²"
            },
            {
                url: "/hdf5dataset"
                file: filename
                dataset: "postprocessing/visibility"
                placeholder: "#visibility"
                image: d3.chart.image()
                    .color_value (d) -> d
                colorbar: Colorbar()
                histogram: d3.chart.histogram()
                title: "visibility"
            },
        ]

        # request phase stepping curves
        phase_stepping_data = {}
        phase_stepping_plot = d3.chart.phase_stepping()

        line_over_update_ps_plot = (line) ->
            d3.select "#phase-stepping-curves"
                .data [line]
                .call phase_stepping_plot
 
        get_request("/hdf5dataset").post get_request_object("postprocessing/phase_stepping_curves"), (error, data) ->
            return console.warn error if error?
            flattened = data.reduce (a, b) -> a.concat b
            placeholder = "#phase-stepping-curves"
            width = $(placeholder).width()
            $(placeholder).height(width * factor)
            phase_stepping_data.phase_stepping_curves = {
                name: "phase_stepping_curves"
                values: data
            }
            get_request("/hdf5dataset").post get_request_object("postprocessing/flat_parameters"), (error, flatpars) ->
                return console.warn error if error?
                phase_stepping_data.flat_parameters = {
                    name: "flat"
                    values: flatpars
                }
                get_request("/hdf5dataset").post get_request_object("postprocessing/dpc_reconstruction"), (error, dpcreco) ->
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
            get_request(image.url).post get_request_object(image.dataset), (error, data) ->
                return console.warn error if error?

                d3.select image.placeholder
                    .data [data]
                    .call image.image

                margin = image.image.margin()
                $(image.placeholder).height(image.image.height() + margin.top + margin.bottom)

                image.colorbar
                    .scale image.image.color()
                    .origin {
                        x: margin.left
                        y: image.image.height() + margin.top
                    }
                    .barlength image.image.width()
                    .thickness 10
                    .orient "horizontal"

                d3.select image.placeholder
                    .call image.colorbar

                image.image.on "line_over", line_over_update_ps_plot


                if image.histogram
                    histogram_placeholder = image.placeholder + "-distribution"
                    flattened = data.reduce (a, b) -> a.concat b
                    sorted = flattened.sort()
                    width = $(histogram_placeholder).width()
                    $(histogram_placeholder).height(width * factor)
                    image.histogram
                        .x_scale()
                        .domain [0, d3.quantile(sorted, 0.98)]
                        .nice()
                    image.histogram
                        .n_bins 50
                        .width width
                        .height width * factor
                        .value (d) -> d
                        .x_title image.title
                        .y_title "pixels"
                    d3.select histogram_placeholder
                        .data [flattened]
                        .call image.histogram

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
