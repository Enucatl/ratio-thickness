jQuery ->

    $("#select-dataset").select2 {
        ajax: {
            url: "/datasets"
            dataType: "json"
            results: (data) ->
                {
                    results: data.map (item) ->
                        {id: item.file, text: item.name}
                }
        }
    }
