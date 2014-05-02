$ = jQuery
$ ->
  #############################
  # =>      Variables

  dropTarget = $('#images_upload')
  $imageUploadForm = $('#s3_uploader')
  $imageUploadsContainer = $('#property_images')

  console.log "property creation loaded"

  #############################
  # =>      Named Functions

  # Pending Image dotdot
  dotDotDot = (target, speed) -> 
    dotCount = 1
    dot = () ->
      dotCount = 1 if dotCount % 50 == 0
      $(target).text( Array(dotCount+1).join('.') )
      dotCount += 1
      return true
    setInterval dot, speed

  #############################
  # =>      Actions

  dropTarget.on
    mouseup: (e) ->
      e.preventDefault()
      window["link_clicked"] = true
      console.log "clicky click"
      $("input#hidden_file_input").click()
      window["link_clicked"] = false

  do -> 
    $imageUploadForm.S3Uploader
      remove_completed_progress_bar: false
      progress_bar_target: $imageUploadsContainer
  
    $imageUploadForm.bind
      s3_upload_failed: (e, content) ->
        console.log content.filename + ' failed to upload'
      s3_upload_worked: (e, content) ->
        console.log content.filename + ' failed to upload'
      s3_uploads_complete: (e) ->
        $("a.btn").removeClass("disabled").text("Publish and Share")
      s3_uploads_start: (e) ->
        $("a.btn").addClass("disabled").text("Uploading")

  #############################
  # =>      Page Run

  dotDotDot('div.processing_image .dot', 1000)