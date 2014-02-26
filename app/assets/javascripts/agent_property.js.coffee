jQuery ->
  $ = jQuery
  console.log "hi"
  $("ul#property_images").on "click", ".actions li", ->
    $this = $(this)
    action = $this.data("action")
    $image = $this.parents("li.property_image").first()
    height = $image.height()
    if action == "arrow"
      $input = $("input#property_images_attributes_" + $this.data("pos") + "_" + $this.data("input") )
      if $this.data("direction") == "up"
        $target = $image.prev("li.property_image")
        incr = -1
      else 
        incr = +1
        $target = $image.next("li.property_image")
      newPos = parseInt($input.val()) + incr
      if newPos >= 0
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


  $(".focusOut").blur -> 
    $(this).parents("form").submit()

      # $image.exchangePositionWith("#property_images li.property_image:eq(" + $image.data("eq") + ")" );
