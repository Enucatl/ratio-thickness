if not d3.chart?
    d3.chart = {}

d3.chart.profile = ->
    margin = {top: 20, right: 20, bottom: 20, left: 20}
    width = 555
    height = 400
    x_value = (d, i) -> i
    y_value = (d, i) -> d
    x_scale = d3.scale.ordinal()
    y_scale = d3.scale.linear()
    x_axis = d3.svg.axis()
        .scale x_scale 
        .orient "bottom"
    x = (d) ->
        x_scale(d[0])
    y = (d) ->
        y_scale(d[1])
    line = d3.svg.line()
        .x x 
        .y y 

    chart = (selection) ->
        selection.each (data) ->

            #convert to standard format
            data = data.map (d, i) ->
                [x_value.call(data, d, i), y_value.call(data, d, i)]

            console.log "data converted", data
            #update scales
            x_scale
                .domain d3.extent data, (d) -> d[0] 
                .rangePoints [0, width - margin.left - margin.right], 0
            y_scale
                .domain [0, 1.1]
                .range [height - margin.top - margin.bottom, 0]

            #select the svg if it exists
            svg = d3.select this
                .selectAll "svg"
                .data [data]

            #otherwise create the skeletal chart
            g_enter = svg.enter()
                .append "svg"
                .append "g"

            g_enter.append "path"
                .classed "line", true
            g_enter.append "g"
                .classed "x axis", true

            #update the dimensions
            svg
                .attr "width", width
                .attr "height", height

            #update position
            g = svg.select "g"
                .attr "transform", "translate(#{margin.left}, #{margin.top})"

            #update the line path
            g.select ".line"
                .attr "d", line

            #update the x axis
            g.select ".x.axis"
                .attr "transform", "translate(0, #{y_scale.range()[0]})"
                .call x_axis

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

    chart.margin = (value) ->
        if not arguments.length
            return margin
        margin = value
        chart

    chart.x = (value) ->
        if not arguments.length
            return x_value
        x_value = value
        chart

    chart.y = (value) ->
        if not arguments.length
            return y_value
        y_value = value
        chart

    chart
