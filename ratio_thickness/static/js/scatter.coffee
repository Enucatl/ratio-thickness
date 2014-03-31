if not d3.chart?
    d3.chart = {}

d3.chart.scatter = ->
    margin = {top: 20, right: 20, bottom: 20, left: 30}
    width = 900
    height = 600
    x_value = (d, i) -> i
    y_value = (d, i) -> d
    x_scale = d3.scale.linear()
    y_scale = d3.scale.linear()
        .domain [0, 6]
    x_axis = d3.svg.axis()
        .scale x_scale 
        .orient "bottom"
    y_axis = d3.svg.axis()
        .scale y_scale 
        .orient "left"

    chart = (selection) ->
        selection.each (data) ->
            #convert to standard format
            data = data.map (d, i) ->
                {
                    x: x_value.call(data, d, i),
                    y: y_value.call(data, d, i)
                }

            #update scales
            x_scale
                .domain d3.extent data, (d) -> d.x
                .range [0, width - margin.left - margin.right]
                .nice()
            y_scale
                .range [height - margin.top - margin.bottom, 0]

            #select the svg if it exists
            svg = d3.select this
                .selectAll "svg"
                .data [data]

            #otherwise create the skeletal chart
            g_enter = svg.enter()
                .append "svg"
                .append "g"

            g_circles = g_enter.append "g"
                .classed "circles", true
            g_enter.append "g"
                .classed "x axis", true
            g_enter.append "g"
                .classed "y axis", true

            #update the dimensions
            svg
                .attr "width", width
                .attr "height", height

            #update position
            g = svg.select "g"
                .attr "transform", "translate(#{margin.left}, #{margin.top})"

            #update the line path
            g_circles
                .selectAll ".circle"
                .data(data)
                .enter()
                .append "circle"
                .classed "circle", true
                .style "fill", "darkblue"
                .attr "r", 3
                .attr "cx", (d) -> x_scale(d.x)
                .attr "cy", (d) -> y_scale(d.y)

            #update axes
            g.select ".x.axis"
                .attr "transform", "translate(0, #{y_scale.range()[0]})"
                .call x_axis
            g.select ".y.axis"
                .call y_axis

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

    chart.x_scale = (value) ->
        if not arguments.length
            return x_scale
        x_scale = value
        chart

    chart.y_scale = (value) ->
        if not arguments.length
            return y_scale
        y_scale = value
        chart

    chart
