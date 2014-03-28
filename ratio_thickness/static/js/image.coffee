if not d3.chart?
    d3.chart = {}

d3.chart.image = ->
    g = undefined
    data = undefined
    width = undefined
    height = undefined
    pixels = undefined
    dispatch = d3.dispatch(chart, "hover")

    chart = (container) ->
        g = container
        pixels = g
            .append("g")
            .attr "id", "image-pixels"

    chart.update = ->
        dx = data[0].length
        dy = data.length

        pixel_height = 8
        pixel_width = 1
        height = pixel_height * dy
        width = pixel_width * dx

        g
            .attr "width", width
            .attr "height", height

        x = d3.scale.ordinal()
            .domain d3.range(dx)
            .rangePoints [0, width - pixel_width], 0
        y = d3.scale.ordinal()
            .domain d3.range(dy)
            .rangePoints [height - pixel_height, 0], 0
        flattened = data.reduce (a, b) -> a.concat b
        sorted = flattened.sort d3.ascending
        min_scale = d3.quantile sorted, 0.05
        max_scale = d3.quantile sorted, 0.95
        color = d3.scale.linear()
            .domain [min_scale, max_scale] 
            .range ["white", "black"]

        layout = []
        for i in [0..(dx - 1)]
            for j in [0..(dy - 1)]
                layout.push {
                    row: i
                    col: j
                    value: data[j][i]
                }

        rectangles = pixels.selectAll "rect"
            .data layout

        rectangles.enter()
            .append "rect"
            .classed "image-pixels", true
            .attr "x", (d) -> x(d.row)
            .attr "y", (d) -> y(d.col)
            .attr "height", pixel_height
            .attr "width", pixel_width
            .attr "fill", (d) -> color(d.value)
            .transition()

        rectangles.exit()
            .transition()
            .remove()
        
        chart.highlight = (data) ->
            console.log "image highlight", data

    chart.data = (value) ->
        if not arguments.length
            return data
        data = value
        chart
    chart.width = (value) ->
        if not arguments.length
            return width
        width = value
        chart
    chart.height = (value) ->
        if not arguments.length
            return height
        height = value
        chart

    d3.rebind chart, dispatch, "on"
