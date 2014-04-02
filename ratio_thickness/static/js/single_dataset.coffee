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
            .key 0
        df_image = d3.chart.image()
            .key 1

        profiles = d3.chart.profile()

        factor = 0.618
        d3.json "/pipelineoutput/40000", (error, json) ->
            return console.warn error if error?
            d3.select "#abs-image"
                .data [json]
                .call abs_image
            d3.select "#df-image"
                .data [json]
                .call df_image

            profile_data = {
                row: 0
                absorption: json[0][0]
                dark_field: json[1][0]
                mask: json[2][0]
            }

            width = $("#profiles").width()
            profiles.width width
            profiles.height factor * width
            d3.select "#profiles"
                .data [profile_data]
                .call profiles

            abs_image.on "line_over", (line) ->
                d3.select "#profiles"
                    .data [line]
                    .call profiles

            df_image.on "line_over", (line) ->
                d3.select "#profiles"
                    .data [line]
                    .call profiles


        ratio_pos = d3.chart.scatter()
        ratio_abs = d3.chart.scatter()
        ratio_df = d3.chart.scatter()
        d3.json "/pipelineoutput/40001", (error, json) ->
            return console.warn error if error?

            ratio_pos.x_scale().domain [0, json[2].length]
            ratio_pos.y_scale().domain [0, 6]
            placeholder = "#ratio-position"
            width = $(placeholder).width()
            ratio_pos.width width
            ratio_pos.x_title "row"
            ratio_pos.y_title "log ratio"
            ratio_pos.height width * factor
            ratio_pos_data = json[2].map (d, i) ->
                [i, d]
            d3.select placeholder
                .data [ratio_pos_data]
                .call ratio_pos

            placeholder = "#ratio-abs"
            width = $(placeholder).width()
            ratio_abs.width width
            ratio_abs.x_scale().domain [0, 1]
            ratio_abs.y_scale().domain [1, 5]
            ratio_abs.x_title "transmission"
            ratio_abs.y_title "log ratio"
            ratio_abs.height width * factor
            ratio_abs_data = json[0].map (d, i) ->
                [d, json[2][i]]
            d3.select placeholder
                .data [ratio_abs_data]
                .call ratio_abs

            placeholder = "#ratio-df"
            width = $(placeholder).width()
            ratio_df.width width
            ratio_df.height width * factor
            ratio_df.x_scale().domain [0, 1]
            ratio_df.y_scale().domain [1, 5]
            ratio_df.x_title "dark field"
            ratio_df.y_title "log ratio"
            ratio_df_data = json[1].map (d, i) ->
                [d, json[2][i]]
            d3.select placeholder
                .data [ratio_df_data]
                .call ratio_df
