if not d3.chart?
    d3.chart = {}

d3.chart.image = ->
    pixel_height = 8
    pixel_width = 1
    key = undefined
    x = d3.scale.ordinal()
    y = d3.scale.ordinal()
    color = d3.scale.linear()
    dispatch = d3.dispatch "line_over", "line_out"

    chart = (selection) ->
        selection.each (data) ->

            #get the right key from the object
            this_data = data[key]
            dx = this_data[0].length
            dy = this_data.length

            pixel_height = 8
            pixel_width = 1
            height = pixel_height * dy
            width = pixel_width * dx

            layout = []
            for i in [0..(dx - 1)]
                for j in [0..(dy - 1)]
                    layout.push {
                        col: i
                        row: j
                        value: this_data[j][i]
                    }

            #select the svg if it exists
            svg = d3.select this
                .selectAll "svg"
                .data [layout]

            #otherwise create the skeletal chart
            g_enter = svg.enter()
                .append "svg"
                .append "g"
            g_enter.selectAll ".pixel"
                .data (d) -> d
                .enter()
                .append "rect"
                .classed "pixel", true

            #update the dimensions
            svg
                .attr "width", width
                .attr "height", height

            #update scales
            x
                .domain d3.range(dx)
                .rangePoints [0, width - pixel_width], 0
            y
                .domain d3.range(dy)
                .rangePoints [height - pixel_height, 0], 0

            #fix color scale
            flattened = this_data.reduce (a, b) -> a.concat b
            sorted = flattened.sort d3.ascending
            min_scale = d3.quantile sorted, 0.05
            max_scale = d3.quantile sorted, 0.95
            color
                .domain [min_scale, max_scale] 
                .range ["white", "black"]


            g = svg.select "g"

            rectangles = g.selectAll "rect"
                .data (d) -> d
                .attr "x", (d) -> x(d.col)
                .attr "y", (d) -> y(d.row)
                .attr "height", pixel_height
                .attr "width", pixel_width
                .attr "fill", (d) -> color(d.value)
                .on "mouseover", (d) ->
                    dispatch.line_over {
                        row: d.row,
                        absorption: data[0][d.row]
                        dark_field: data[1][d.row]
                        mask: data[2][d.row]
                    }                  
                .on "mouseout", (d) ->
                    dispatch.line_out {
                        row: d.row
                    }

    chart.pixel_width = (value) ->
        if not arguments.length
            return pixel_width
        pixel_width = value
        chart

    chart.pixel_height = (value) ->
        if not arguments.length
            return pixel_height
        pixel_height = value
        chart

    chart.key = (value) ->
        if not arguments.length
            return key
        key = value
        chart

    chart.x = (value) ->
        if not arguments.length
            return x
        x = value
        chart

    chart.y = (value) ->
        if not arguments.length
            return y
        y = value
        chart

    chart.color = (value) ->
        if not arguments.length
            return color
        color = value
        chart

    d3.rebind chart, dispatch, "on"

    chart
