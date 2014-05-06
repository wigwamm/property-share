jQuery ->
  #############################
  # =>      Vars

  $ = jQuery
  $buttons = $(".image_form").children("a")

  #############################
  # =>      Functions

  submitForm = ->
    $('#property_images_form form').submit()

  updateValues = (oldVal, newVal) ->
    console.log "oldVal", oldVal
    console.log "newVal", newVal
    console.log "----------------"
    direction = if (oldVal - newVal) < 0 then -1 else +1
    $("input.position_input").each ->
      $this = $(this)
      $val = parseInt($this.val())
      $this.val( $val + direction ) if $val < oldVal && $val >= newVal
      $this.val( newVal ) if $val == oldVal
    submitForm()

  #############################
  # =>      Actions

  $("ul#property_images").children('input').each ->
    $(this).prependTo('#hidden_holder')


  $('ul#property_images').sortable
    placeholder: "sortable-highlight",
    axis: "y",
    start: (event, ui) ->
      $(this).data('previndex', ui.item.index());
      $('.sortable-highlight').css("height", ui.item[0].clientHeight )
    update: (event, ui) ->
      updateValues($(this).data('previndex'), ui.item.index())
      $(this).removeAttr('data-previndex')


  $('ul#property_images').delegate '.image_actions a', 'click', (e, ui) ->
      e.preventDefault()
      $this = $(this)
      if $this.data('direction')
        pos = parseInt( $this.siblings('input').first().val() )
        console.log "max", parseInt($this.data('max'))
        console.log "boundry", pos >= 0 && pos <= parseInt($this.data('max'))
        newPos = pos + $this.data('direction')
        $current = $this.parents('li.sortable_images').first()
        console.log newPos
        if newPos >= 0 && newPos <= parseInt($this.data('max'))
          if newPos < pos
            $target = $current.prevAll('li.sortable_images').first()
          else
            $target = $current.nextAll('li.sortable_images').first()

          $target.exchangePositionWith($current)
          updateValues(pos, newPos)

      else if $this.data('action')
        console.log "action", e

  $(".focusOut").on
    blur: -> 
      submitForm()

      # $image.exchangePositionWith("#property_images li.property_image:eq(" + $image.data("eq") + ")" );
