jQuery ->

    window.loadaggregated = ->
        datasets = [
            {
                "name": "PMMA",
                "file": "ratio_thickness/static/data/S00638_S00677.hdf5",
                "a (mm)": 50,
                "b (mm)": 6.3,
            },
            {
                "name": "Plexiglass",
                "file": "ratio_thickness/static/data/S00678_S00717.hdf5",
                "a (mm)": 50,
                "b (mm)": 9.40,
            },
            {
                "name": "Aluminium",
                "file": "ratio_thickness/static/data/S00718_S00757.hdf5",
                "a (mm)": 30.50,
                "b (mm)": 1,
            },
            {
                "name": "Polystyrene",
                "file": "ratio_thickness/static/data/S00758_S00797.hdf5",
                "a (mm)": 62,
                "b (mm)": 20,
            },
            {
                "name": "Carbon fibers",
                "file": "ratio_thickness/static/data/S00918_S00957.hdf5",
                "a (mm)": 49.35,
                "b (mm)": 4.1,
            },
        ]
        factor = 0.618
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

    window.loadaggregated()
