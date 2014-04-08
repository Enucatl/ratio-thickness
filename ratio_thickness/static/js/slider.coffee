if not d3.chart?
    d3.chart = {}

d3.chart.slider = ->
    margin = {top: 20, right: 20, bottom: 20, left: 20}
    width = 900
    height = 600
    x = d3.scale.log()
        .domain [1, 1000]
        .nice()
        .clamp true
    x_axis = d3.svg.axis()
        .scale x
        .orient "bottom"
    x_title = undefined
    brush = d3.svg.brush()
        .extent [0, 0]
    handle = undefined

    dispatch = d3.dispatch "slider_brushended"

    brushed = ->
        value = brush.extent()[0]
        if d3.event.sourceEvent  # not a programmatic event
            value = x.invert d3.mouse(this)[0]
            brush.extent [value, value]
        handle
            .attr "cx", x(value)

    half_breaks = (array) ->
        last = array.slice(1)
        first = array.slice(0, -1)
        last.map (d, i) ->
            first[i] + (d - first[i]) / 2

    round_to_nearest_tick = (extent) ->
        ticks = x.ticks(x_axis.ticks()[0])
        domain = half_breaks ticks
        value = extent[0]
        thresholds = d3.scale.threshold()
            .domain half_breaks ticks
            .range ticks
        [thresholds(value), thresholds(value)]
            
    brushended = ->
        if not d3.event.sourceEvent
            # only transition after input
            return  
        extent = round_to_nearest_tick brush.extent()
        d3.select this
            .call brush.extent extent
        handle
            .transition()
            .attr "cx", x(extent[1])
        dispatch.slider_brushended extent[1]

    chart = (selection) ->
        selection.each (data) ->

            x
                .range [0, width - margin.left - margin.right]

            brush
                .x x
                .on "brush", brushed
                .on "brushend", brushended

            #select svg
            svg = d3.select this
                .selectAll "svg"
                .data [1]

            #create skeleton if svg doesn't exist
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
            g_enter.append "circle"
                .classed "handle", true
                .classed "slider", true
            g_enter.append "g"
                .classed "slider", true

            #update the data
            svg.select "g"
                .attr "transform", "translate(#{margin.left}, #{margin.top})"

            svg
                .attr "width", width
                .attr "height", height

            slider = svg.select ".slider"
                .call brush

            slider.select ".background"
                .attr "height", height - margin.top - margin.bottom

            slider.selectAll ".extent,.resize"
                .remove()

            axis_height = (height - margin.top - margin.bottom) / 2
            handle = svg.select ".handle"
                .attr "transform", "translate(0, #{axis_height})"
                .attr "r", 5

            slider
                .call brush.event

            svg.select ".x.axis"
                .attr "transform", "translate(0, #{axis_height})"
                .call x_axis
                .select ".domain" 
                .classed "slider", true
                .select -> this.parentNode.appendChild this.cloneNode true
                    .classed "halo", true

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
            return x
        x = value
        x_axis.scale x
        chart

    chart.x_title = (value) ->
        if not arguments.length
            return x_title
        x_title = value
        chart

    chart.x_axis = (value) ->
        if not arguments.length
            return x_axis
        x_axis = value
        chart

    chart.brush = (value) ->
        if not arguments.length
            return brush
        brush = value
        chart

    d3.rebind chart, dispatch, "on"

    chart
