jQuery ->

    window.loadaggregated = ->
        slider = d3.chart.slider()
            .width $("#slider").width()
            .height 100
            .x_title "maximum log ratio"

        slider
            .x_axis()
            .tickFormat (d) ->
                slider.x().tickFormat(3, d3.format "d") d 
        d3.select "#slider"
            .data [0]
            .call slider

        names = ["simulation", "materials"]
        color_slider_scale = d3.scale.linear()
        color_slider_axis = d3.svg.axis()
            .scale color_slider_scale
            .ticks 1
            .tickFormat (d) -> names[d]

        color_slider = d3.chart.slider()
            .width $("#color-slider").width()
            .height 100
            .x_title "color coding"
            .x color_slider_scale
            .x_axis color_slider_axis
            .margin {top: 20, right: 40, bottom: 20, left: 40}

        d3.select "#color-slider"
            .data [0]
            .call color_slider

        plots = [{ 
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



        d3.json "/datasets", (error, datasets) ->
            return console.warn error if error?
            factor = 0.618
            request = d3.xhr("/aggregatedoutput")
            request.mimeType "application/json"
            request.response (request) ->
                JSON.parse request.responseText
            request.post JSON.stringify(datasets), (error, data) ->
                return console.warn error if error?
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

                slider.on "slider_brushended", (maximum) ->
                    for plot in plots
                        plot.y_scale_domain[1] = maximum
                        plot.plot.y_scale()
                            .domain plot.y_scale_domain
                        d3.select plot.placeholder
                            .call plot.plot

                color_slider.on "slider_brushended", (value) ->
                    if value == 0
                        f = (d) ->
                            if d.simulated then "simulated" else "real data"
                    else
                        f = (d) -> d.name
                    for plot in plots
                        plot.plot.color_value f
                        d3.select plot.placeholder
                            .data [data]
                            .call plot.plot

    window.loadaggregated()
