jQuery ->
  $ = jQuery
  totalFiles = 0
  completedFiles = 0

  dropInput =  '<div class="image_hide">
                  <div class="dz-preview dz-file-preview">
                    <img data-dz-thumbnail />
                    <h4><span data-dz-name></span></h4>
                  </div>
                </div>'

  loader = '<div class="spinner">
              <div class="dot1"></div>
              <div class="dot2"></div>
            </div>
            <h1> Uploading </h1>'

  urlify = (text) ->
    return text.replace(/\ /g, "_").toLowerCase()

  Dropzone.options.createProperty = 
    paramName: "property[images_attributes]"
    selector: "photo"
    acceptedFiles: "image/*"
    maxFilesize: 12
    parallelUploads: 20
    createImageThumbnails: true
    autoProcessQueue: false
    uploadMultiple: true
    thumbnailWidth: 1000
    thumbnailHeight: 400
    previewTemplate: dropInput
    previewsContainer: "#property_images"
    clickable: "#images_upload"
    dictDefaultMessage: " "
    init: ->
      dropArea = $("#images_upload")
      submitButton = $("a#submit_form")

      this.on "addedfile", (file) ->
        totalFiles += 1
        $(".image_hide").fadeIn(800)
        dropArea.children("p").text " "
        suffix =  if totalFiles == 1 then " photo added" else " photos added"
        dropArea.children("h2").text totalFiles + suffix
        dropArea.children("h2").text totalFiles + suffix 

      this.on "removedfile", ->
        totalFiles -=1

      this.on "successmultiple", (file) ->
        console.log "done done"
        property = $.parseJSON(file[0].xhr.response)
        window.location.href = "/" + property.url;

      myDropzone = this
      submitButton.on click: (event) ->
        
        event.preventDefault()
        $("#overlay_content").html(loader)
        myDropzone.processQueue()

  $("input#property_title").on "keyup paste focusout", ->
      $("#prop_title").text this.value
      $("input#property_url").val urlify(this.value)

  $("textarea#property_description").on "keyup paste focusout", ->
      $("#prop_description").text this.value

  $("input#property_price").on "keyup paste focusout", ->
      $("#prop_price").text this.value

  $("input#property_postcode").on "focusout", ->
    if this.value.length >= 5
      $("#preview_property_map").stop().animate
        height: "60px",
        opacity: 1
      , 600, "easeInOutElastic"