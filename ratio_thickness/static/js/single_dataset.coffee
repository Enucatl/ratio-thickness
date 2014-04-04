jQuery ->

    window.loadimages = (title, filename) ->
        $("#page-title").text("Dataset analysis: #{title}")
        #send file name to the pipeline
        jQuery.ajax {
            url: "/pipeline"
            type: "POST"
            contentType: "application/json"
            dataType: "json"
            data: JSON.stringify({
                filename: filename
            })
        }

        abs_image = d3.chart.image()
        df_image = d3.chart.image()
            .color_value (d) -> d[1]

        profiles = d3.chart.profile()

        factor = 0.618
        d3.json "/pipelineoutput/40000", (error, json) ->
            return console.warn error if error?
            d3.select "#abs-image"
                .data [json]
                .call abs_image
            d3.select "#df-image"
                .data [json]
                .call df_image

            profile_data = {
                row: 0
                values: json[0]
            }

            width = $("#profiles").width()
            profiles.width width
            profiles.height factor * width
            d3.select "#profiles"
                .data [profile_data]
                .call profiles

            for image in [abs_image, df_image]
                image.on "line_over", (line) ->
                    d3.select "#profiles"
                        .data [line]
                        .call profiles

        d3.json "/pipelineoutput/40001", (error, json) ->
            return console.warn error if error?
            data = [{
                name: title
                values: json
            }]
            plots = [
                { 
                    placeholder: "#ratio-position"
                    plot: d3.chart.scatter()
                    x_scale_domain: [0, json.length]
                    y_scale_domain: [0, 1]
                    x_title: "row"
                    y_title: "log ratio"
                    x_value: (d, i) -> i
                    y_value: (d, i) -> d[2]
                },
                { 
                    placeholder: "#ratio-abs"
                    plot: d3.chart.scatter()
                    x_scale_domain: [0, 1]
                    y_scale_domain: [0, 1]
                    x_title: "transmission"
                    y_title: "log ratio"
                    x_value: (d, i) -> d[0]
                    y_value: (d, i) -> d[2]
                },
                { 
                    placeholder: "#ratio-df"
                    plot: d3.chart.scatter()
                    x_scale_domain: [0, 1]
                    y_scale_domain: [0, 1]
                    x_title: "dark field"
                    y_title: "log ratio"
                    x_value: (d, i) -> d[1]
                    y_value: (d, i) -> d[2]
                },
            ]

            for plot in plots
                width = $(plot.placeholder).width()
                plot.plot.width width
                plot.plot.x_title plot.x_title
                plot.plot.y_title plot.y_title
                plot.plot.x_scale()
                    .domain plot.x_scale_domain
                plot.plot.y_scale()
                    .domain plot.y_scale_domain
                plot.plot.height width * factor
                plot.plot.x_value plot.x_value
                plot.plot.y_value plot.y_value
                d3.select plot.placeholder
                    .data [data]
                    .call plot.plot

    $("#select-dataset").change ->
        file = $(this).val()
        name = $(".select2-chosen").text()
        window.loadimages(name, file)

    jQuery.ajax {
        url: "/datasets"
        dataType: "json"
        success: (data, s, xhr) ->
            data = data[4]
            window.loadimages(data.name, data.file)
    }
