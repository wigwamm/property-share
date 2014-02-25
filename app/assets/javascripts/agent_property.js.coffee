jQuery ->
  $ = jQuery
  console.log "hi"
  # $("ul#property_images").on "click", ".actions li", ->
  #   $input = $("input#property_images_attributes" + $this.data("pos") + "_" + $this.data("input") )

  #     if $this.data("input") == "position"
  #     if action == "arrow"

  $("ul#property_images").on "click", ".actions li", ->
    $this = $(this)
    action = $this.data("action")
    $image = $this.parents("li.property_image").first()
    if action == "arrow"
      $input = $("input#property_images_attributes_" + $this.data("pos") + "_" + $this.data("input") )
      if $this.data("direction") == "up"
        $target = $image.prev("li.property_image")
        incr = -1
      else 
        incr = +1
        $target = $image.next("li.property_image")
      newPos = parseInt($input.val()) + incr
      if newPos > 0
        $input.val(newPos)
        $target.exchangePositionWith($image)
        console.log $input.val()

      # $this.parents("form").submit()

  $(".focusOut").blur -> 
    $(this).parents("form").submit()

      # $image.exchangePositionWith("#property_images li.property_image:eq(" + $image.data("eq") + ")" );
