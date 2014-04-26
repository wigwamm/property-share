# need to stop coffee script from wrapping in self executing  

$ = jQuery
$s3_uploader = $('#s3_uploader')

$s3_uploader.S3Uploader
  remove_completed_progress_bar: true,
  additional_data: { assets_uuid: $s3_uploader.data('assetsuuid') }
  progress_bar_target: $('.upload_bars')
  allow_multiple_files: true
  accepted_types: '^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$'

$s3_uploader.on 
  s3_upload_complete: (e, content) ->
    console.log (content.filename + ' upload complete')

  s3_upload_success: (e, content) ->
    console.log (content.filename + ' upload successfull')

  s3_files_added: (e, content) ->
    $("input#property_photo_count").val(window.totalImageCount)
    console.log (content.filename + ' added')

  s3_uploads_start: (e) ->
    console.log "upload started"

  s3_upload_failed: (e, content) -> 
    console.log (content.filename + ' failed to upload')
    
  s3_uploads_complete: (e, content) ->
    console.log "uploads complete"
    window.totalUploadComplete = true
    window.totalUploadPercent = 101

dropTarget = $('#images_upload')
uploadContent = '<h2><span class="added_count">0</span> Images Added</span> : <span class="uploaded_count">0</span> Uploaded</span></h2>'

dropTarget.on
  mouseup: (e) ->
    e.preventDefault()
    window["link_clicked"] = true
    $('#hidden_file_input').click()
    window["link_clicked"] = false
  dragover: (e) ->
    console.log "dragging"
  drop: (e) ->
    e.preventDefault()
    $('.upload_text').html(uploadContent)
    console.log "dropped"
    console.log e

$("input#property_title").on "keyup paste focusout", ->
  $("#prop_title").text this.value

$("textarea#property_description").on "keyup paste focusout", ->
  $("#prop_description").text this.value

$("input#property_price").on "keyup paste focusout", ->
  $("#prop_price").text this.value

$("input#property_postcode").on
  # "keyup paste focusout": ->
  # 
  "focusout": ->
    if this.value.length >= 5
      $("#preview_property_map").stop().animate
        height: "60px",
        opacity: 1
      , 600, "easeInOutElastic"

########################################################
#####     Jquery Validator 

$.validator.addMethod "postalzip", (value, element) ->
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

propertyValidator = $('#create-property').validate
  debug: true
  ignore: []
  errorElement: "p"
  wrapper: "div"
  errorClass: "error"
  focusout: true
  rules:
    "property[title]":
      required: true
    "property[street]":
      required: true
    "property[postcode]": 
      required: true
      postalzip: true
    "property[price]":
      required: true
    "property[photo_count]":
      required: true
      min: 0
  messages:
    "property[title]":
      required: "You're missing a title"
    "property[street]":
      required: "Both a street and postcode are required"
    "property[postcode]": 
      required: "Both a street and postcode are required"
      postalzip: "Sorry it doesn't look like that's a UK postcode"
    "property[price]":
      required: "Price is require"
    "property[photo_count]":
      min: "Please add some photos"

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
     # do other things for a valid form
    # if window.totalImageCount >= 1
    #   NProgress.configure
    #     minimum: 0.2
    #   NProgress.start()
    #   console.log "form ready"

    #   setTimeout ->
    #     $('#form_wrapper').fadeOut 800, ->
    #       $('#sharebox').fadeIn()

    #     loadingBar = setInterval ->

    #       if window.totalUploadPercent < 100 && !window.totalUploadComplete
    #         console.log window.totalUploadPercent
    #         NProgress.inc() if window.totalUploadPercent >=60
    #         # NProgress.set
    #       else
    #         # NProgress.done()
    #         $("#prop_link a").removeClass("btn_grey").text("View Property")
    #         NProgress.done()
    #         clearInterval( loadingBar )
    #     , 2000
    #   , 1000

    #   $.rails.handleRemote( $(form) )
    # else
    #   $("div.error_messages").html("<p> please add them</p>")




