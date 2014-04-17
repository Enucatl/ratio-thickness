if not d3.chart?
    d3.chart = {}

d3.chart.phase_stepping = ->
    margin = {top: 20, right: 20, bottom: 20, left: 30}
    width = 900
    height = 600
    x_scale = d3.scale.linear()
    y_scale = d3.scale.linear()
    color_scale = d3.scale.category20()
    x_axis = d3.svg.axis()
        .scale x_scale 
        .orient "bottom"
    y_axis = d3.svg.axis()
        .scale y_scale 
        .orient "left"
    x_title = undefined
    y_title = undefined
    data = undefined
    chart = (selection) ->
        selection.each (i, j) ->
                 
            #update scales
            x_scale
                .domain data.phase_stepping_curves.values[i][j].length
                .range [0, width - margin.left - margin.right]
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
            g_enter.append "g"
                .classed "x axis", true
                .append "text"
                .classed "label", true
                .attr "x", width - margin.right - margin.left
                .attr "y", -6
                .style "text-anchor", "end"
                .text x_title
            g_enter.append "g"
                .classed "y axis", true
                .append "text"
                .classed "label", true
                .attr "y", 6
                .attr "transform", "rotate(-90)"
                .attr "dy", ".71em"
                .style "text-anchor", "end"
                .text y_title
            g_enter.append "g"
                .classed "flat line", true
            g_enter.append "g"
                .classed "sample line", true
            g_enter.append "g"
                .classed "circles", true

            #update the dimensions
            svg
                .attr "width", width
                .attr "height", height

            #update position
            g = svg.select "g"
                .attr "transform", "translate(#{margin.left}, #{margin.top})"

            #update circles
            circles = g.select ".circles"
                .selectAll ".circle"
                .data data.phase_stepping_curves.values[i][j]

            circles
                .enter()
                .append "circle"
                .classed "circle", true

            circles
                .transition()
                .duration(500)
                .attr "r", 3
                .attr "cx", (d, i) -> x_scale(i)
                .attr "cy", (d) -> y_scale(d)

            circles
                .exit()
                .remove()

            ##update legend
            #legends = g.select "g.legends"
                #.selectAll "g.legend"
                #.data color_scale.domain()

            #l_enter = legends
                #.enter()
                #.append "g"
                #.classed "legend", true

            #legends
                #.each (d) ->
                    #rects = d3.select this
                        #.selectAll "rect"
                        #.data [d]
                    #rects.enter()
                        #.append "rect"
                        #.attr "x", width - margin.right - margin.left - 18
                        #.attr "width", 18
                        #.attr "height", 18
                    #rects
                        #.style "fill", color_scale
                    #texts = d3.select this
                        #.selectAll "text"
                        #.data [d]
                    #texts.enter()
                        #.append "text"
                        #.attr "x", width - margin.right - margin.left - 24
                        #.attr "y", 9
                        #.attr "dy", ".35em"
                        #.style "text-anchor", "end"
                    #texts
                        #.text (d) -> d

            #legends
                #.attr "transform", (d, i) -> "translate(0, #{20 * i})"

            #legends
                #.exit()
                #.remove()

            #update axes
            g.select ".x.axis"
                .attr "transform", "translate(0, #{y_scale.range()[0]})"
                .call x_axis

            g.select ".y.axis"
                .transition()
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

    chart.x_value = (value) ->
        if not arguments.length
            return x_value
        x_value = value
        chart

    chart.color_value = (value) ->
        if not arguments.length
            return color_value
        color_value = value
        chart

    chart.y_value = (value) ->
        if not arguments.length
            return y_value
        y_value = value
        chart

    chart.x_title = (value) ->
        if not arguments.length
            return x_title
        x_title = value
        chart

    chart.y_title = (value) ->
        if not arguments.length
            return y_title
        y_title = value
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

    chart.data = (value) ->
        if not arguments.length
            return data
        data = value
        chart

    chart
