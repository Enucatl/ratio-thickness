jQuery ->
    window.loadimages = (filename) ->
        #send file name to the pipeline
        jQuery.ajax {
            url: "/pipeline"
            type: "POST"
            contentType: "application/json"
            dataType: "json"
            data: JSON.stringify({
                filename: filename
            })
        }

        abs_image = d3.chart.image()
        df_image = d3.chart.image()

        d3.json "/pipelineoutput/40000", (error, json) ->
            return console.warn error if error?
            d3.select "#abs-image"
                .data [json]
                .call abs_image
            d3.select "#df-image"
                .data [json]
                .call df_image

        ratio_pos = d3.chart.scatter()
        ratio_abs = d3.chart.scatter()
        ratio_df = d3.chart.scatter()
        d3.json "/pipelineoutput/40001", (error, json) ->
            return console.warn error if error?
            factor = 0.618

            placeholder = "#ratio-position"
            width = $(placeholder).width()
            ratio_pos.width width
            ratio_pos.height width * factor
            console.log json
            ratio_pos_data = json.map (d, i) ->
                [i, json[2][i]]
            d3.select placeholder
                .data [ratio_pos_data]
                .call ratio_pos

            placeholder = "#ratio-abs"
            width = $(placeholder).width()
            ratio_pos.width width
            ratio_pos.height width * factor
            console.log json
            ratio_abs_data = json.map (d, i) ->
                [i, json[0][i]]
            d3.select placeholder
                .data [ratio_abs_data]
                .call ratio_abs

            placeholder = "#ratio-df"
            width = $(placeholder).width()
            ratio_pos.width width
            ratio_pos.height width * factor
            console.log json
            ratio_df_data = json.map (d, i) ->
                [i, json[1][i]]
            d3.select placeholder
                .data [ratio_df_data]
                .call ratio_df
