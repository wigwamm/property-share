$ = jQuery
$ ->
  dropTarget = $('#images_upload')
  console.log "property creation loaded"

  dropTarget.on
    mouseup: (e) ->
      e.preventDefault()
      window["link_clicked"] = true
      console.log "clicky click"
      $("input#hidden_file_input").click()
      window["link_clicked"] = false

