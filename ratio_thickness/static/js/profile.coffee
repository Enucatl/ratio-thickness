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

            console.log "profile data", data
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

            console.log layout

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

            #update the dimensions
            svg
                .attr "width", width
                .attr "height", height

            #update position
            g = svg.select "g"
                .attr "transform", "translate(#{margin.left}, #{margin.top})"

            profile = g.selectAll ".profile"
                .data layout
                .enter()
                .append "g"
                .classed "profile", true

            profile.append "path"
                .classed "line", true
                .attr "d", (d) -> line(d.values)
                .style "stroke", (d) -> color d.name 

            g_enter.append "g"
                .classed "x axis", true
            g_enter.append "g"
                .classed "y axis", true

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
