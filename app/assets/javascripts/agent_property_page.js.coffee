jQuery ->
  $ = jQuery
  $buttons = $("#actions_expand ul").children("a")
  btn = $("input#form_btn")
  btnText = "Book Your Visit"

  $buttons.on
    click: (event) -> 
      event.preventDefault()
      $this = $(this)
      if $this.hasClass( "selected" ) == true
        $buttons.removeClass( "selected" )
        $("#visit_time").val("")
      else
        $buttons.removeClass( "selected" )
        $this.addClass( "selected" )
        $("#visit_availability_id").val($this.data("availabilityid"))
        btn.val( btnText + " @ " + $this.text())

  console.log "hi"

  $("ul#property_images").on "click", ".image_actions li", ->

    $this = $(this)
    action = $this.data("action")
    $image = $this.parents("li.property_image").first()
    height = $image.height()
    console.log action
    console.log height


    if action == "arrow"

      $input = $("input#property_images_attributes_" + $this.data("pos") + "_" + $this.data("input") )

      if $this.data("direction") == "up"
        $target = $image.prev("li.property_image")
        incr = -1

      # else if $this.data("direction") == "upup"
      #   incr = -1
      #   $target = $("li.property_image").first()

      else if $this.data("direction") == "down"
        incr = 1 
        $target = $image.next("li.property_image")

      # else if $this.data("direction") == "downdown"
      #   incr = +1
      #   $target = $("li.property_image").last()

      newPos = parseInt($input.val()) + incr
      console.log $input.val()

      if newPos >= 0
        console.log newPos
        $input.val(newPos)
        $target.exchangePositionWith($image)
        $("ul#property_images form").submit()

    else if action == "main"
      if $this.hasClass("star")
        $input = $("input#property_images_attributes_" + $this.data("pos") + "_" + $this.data("input") )
        $("input.main_image_inputs").each ->
          $(this).val(false)
        $input.val("true")
        $(".star_on").removeClass("star_on").addClass("star")
        $this.removeClass("star").addClass("star_on")
        $("ul#property_images form").submit()

  $(".focusOut").on
    keyUp: ->

    blur: -> 
      $(this).parents("form").submit()

      # $image.exchangePositionWith("#property_images li.property_image:eq(" + $image.data("eq") + ")" );
