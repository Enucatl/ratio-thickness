jQuery ->
    console.log "select2 start"

    select2object = {
        placeholder: "Choose a dataset"
        ajax: {
            url: "/datasets"
            dataType: "json"
            results: (data) ->
                console.log data
                {
                    results: data.map (item) ->
                        {id: item.file, text: item.name}
                }
        }
    }
    console.log select2object

    $("#select-dataset").select2 select2object

    console.log "select2 done"
