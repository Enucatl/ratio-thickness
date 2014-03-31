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
        window.images = [
            {
                placeholder: "abs-reconstruction"
                port: 40000
            },
            {
                placeholder: "df-reconstruction"
                port: 40001
            },
            {
                placeholder: "abs-segmentation-mask"
                port: 40002
            },
            {
                placeholder: "ratio-image"
                port: 40003
            },
        ]
        window.profiles = [
            {
                id: "#abs-reconstruction-profile"
            }
        ]

        set_profiles = (profile) ->
            profile.profile = d3.chart.profile()
            element = $(profile.id)
            factor = 0.618
            profile.profile.width element.width()
            profile.profile.height Math.round(element.width() * factor)

        (set_profiles profile for profile in window.profiles)

        request_json = (image) ->
            placeholder = "##{image.placeholder}"
            port = image.port
            d3.json "/pipelineoutput/#{port}", (error, json) ->
                return console.warn error if error?
                width = $(placeholder).width()
                image.image = d3.chart.image()
                image.image.width width
                svg = d3.select placeholder
                    .append "svg"
                    .attr "id", placeholder.replace "#", ""
                image.image svg
                image.image.data(json)
                image.image.update()

        (request_json image for image in window.images)
