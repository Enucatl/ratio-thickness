if not d3.chart?
    d3.chart = {}

d3.chart.profile = ->
    margin = {top: 20, right: 20, bottom: 20, left: 30}
    width = 555
    height = 400
    color = d3.scale.category10()
    x_scale = d3.scale.linear()
    y_scale = d3.scale.linear()
        .domain [0, 1.2]
    x_axis = d3.svg.axis()
        .scale x_scale 
        .orient "bottom"
    y_axis = d3.svg.axis()
        .scale y_scale 
        .orient "left"
    x = (d) ->
        x_scale(d.col)
    y = (d) ->
        y_scale(d.value)
    line = d3.svg.line()
        .x x 
        .y y 

    chart = (selection) ->
        selection.each (data) ->

            #fix colors
            color
                .domain (d3.keys data).filter (key) ->
                    key != "mask" and key != "row"

            #convert to standard format
            layout = color
                .domain()
                .map (name) ->
                    {
                        name: name,
                        values: data[name].map (d, i) ->
                            {
                                col: i
                                value: d
                            }
                    }

            #update scales
            x_scale
                .domain [0, data["mask"].length]
                .range [0, width - margin.left - margin.right]
            y_scale
                .range [height - margin.top - margin.bottom, 0]

            #select the svg if it exists
            svg = d3.select this
                .selectAll "svg"
                .data [layout]

            #otherwise create the skeletal chart
            g_enter = svg.enter()
                .append "svg"
                .append "g"
            g_enter.append "g"
                .classed "x axis", true
                .append "text"
                .classed "label", true
                .attr "x", width - margin.right - margin.left
                .attr "y", -6
                .style "text-anchor", "end"
                .text "pixel"
            g_enter.append "g"
                .classed "y axis", true
                .append "text"
                .classed "label", true
                .attr "y", 6
                .attr "transform", "rotate(-90)"
                .attr "dy", ".71em"
                .style "text-anchor", "end"
                .text "transmission / dark field"
            g_enter.append "rect"
                .classed "mask", true
            g_enter.selectAll ".line"
                .data (d) -> d
                .enter()
                .append "path"
                .classed "line", true

            #update the dimensions
            svg
                .attr "width", width
                .attr "height", height

            #update position
            g = svg.select "g"
                .attr "transform", "translate(#{margin.left}, #{margin.top})"

            #update mask
            mask_data = [
                data.mask.indexOf(true),
                data.mask.lastIndexOf(true)
            ]

            mask_data = [
                {
                    x: mask_data[0]
                    width: mask_data[1] - mask_data[0]
                }
            ]

            mask = g.select ".mask"
                .data mask_data
                .attr "x", (d) -> x_scale(d.x)
                .attr "y", 0
                .attr "width", (d) -> x_scale(d.width)
                .attr "height", y_scale.range()[0]

            #update lines
            g.selectAll ".line"
                .data (d) -> d
                .attr "d", (d) -> line(d.values)
                .style "stroke", (d) -> color d.name 

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
