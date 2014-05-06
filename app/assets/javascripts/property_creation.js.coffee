$ = jQuery
$ ->
  #############################
  # =>      Variables

  dropTarget = $('#images_upload')
  $imageUploadForm = $('#s3_uploader')
  $imageUploadsContainer = $('#property_images')

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

  console.log "property creation loaded"

  $("select").selectBoxIt
    autoWidth: false
    aggressiveChange: true

  $('.no_click').on
    click: (e) ->
      e.preventDefault

  ########################################################
  #####     Jquery Validator 
  
  $.validator.addMethod "postalzip", (value, element) ->
    return this.optional(element) || /[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2}/g.test(value)
  , "No zip or postcode"

  $.validator.addMethod "spaced", (value, element) ->
    return this.optional(element) || /[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2}/g.test(value)
  , "No zip or postcode"

  error_message = (object, target) ->
    formErrors = object.numberOfInvalids()
    target = $(target)
    if formErrors
      message = if formErrors == 1 then "<p>" + object.errorList[0].message + "</p>" else '<p>Please fill in the form correctly, there\'s ' + formErrors + ' errors</p>';
      target.html(message)
      target.slideDown()
    else
      target.slideUp()

  propertyValidator = $('#property-form').validate
    debug: false
    ignore: []
    errorElement: "p"
    wrapper: "div"
    errorClass: "error"
    focusout: true
    rules:
      "property[title]":
        required: true
        minlength: 6
      "property[street]":
        required: true
        minlength: 8
      "property[postcode]": 
        required: true
        postalzip: true
      "property[price]":
        required: true
        minlength: 2
    messages:
      "property[title]":
        required: "You're missing a title"
        minlength: "You're title's too short"
      "property[street]":
        required: "Both a street and postcode are required"
        minlength: "Both a street and postcode are required"
      "property[postcode]": 
        required: "Both a street and postcode are required"
        postalzip: "Sorry it doesn't look like that's a UK postcode"
      "property[price]":
        required: "Price is require"
        minlength: "that seems a little cheap"

    errorPlacement: (label, element) ->
      label.addClass('error_message')
      # label.insertAfter(element)
    
    highlight: (element, errorClass, validClass) ->
      $element = $(element)
      if $element.data('highlight')
        $($element.data('highlight')).addClass(errorClass + " invalid").removeClass(validClass)
      else
        $element.addClass(errorClass + " invalid").removeClass(validClass)
    
    unhighlight: (element, errorClass, validClass) ->
      $element = $(element)
      if $element.data('highlight')
        $($element.data('highlight')).removeClass(errorClass + " invalid").addClass(validClass)
      else
        $element.removeClass(errorClass + " invalid").addClass(validClass)
      error_message(propertyValidator, "div.error_messages")
    
    invalidHandler: (event, validator) ->
      error_message(validator, "div.error_messages")

    submitHandler: (form) ->
      console.log "submitting"
      form.submit()

  #############################
  # =>      Page Run

  dotDotDot('div.processing_image .dot', 1000)