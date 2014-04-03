jQuery ->
    d3.json "/datasets", (error, json) ->
        return console.warn error if error?

        #select table if it exists
        table = d3.select "#dataset-table"
            .selectAll "table"
            .data [json]

        #otherwise create skeleton
        enter = table.enter()

        enter.append "thead"
        enter.append "tbody"

        head = d3.select "#dataset-table"
            .select "thead"
            .selectAll "tr"
            .data [["material", "min thickness (mm)", "max thickness (mm)"]]

        head
            .enter()
            .append "tr"
            .append "th"

        head.selectAll "th"
            .data (d) -> d
            .enter()
            .append "th"

        head.selectAll "th"
            .text (d) -> d

        head.exit().remove()

        rows = d3.select "#dataset-table"
            .select "tbody"
            .selectAll "tr"
            .data json

        rows
            .enter()
            .append "tr"
            .append "td"

        cells = rows.selectAll "td"
            .data (d) -> [d["name"], d["b (mm)"], d["a (mm)"]]
            .enter()
            .append "td"

        rows.selectAll "td"
            .text (d) -> d

        rows.exit().remove()
