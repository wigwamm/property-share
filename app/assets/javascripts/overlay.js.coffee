jQuery ->
  $ = jQuery
  centerOverlay = () ->
    $oc = $("#overlay_content")
    oh = $oc.outerHeight()
    wh = $(window).height()
    mt = ( (wh - oh)/ 2 ) + 30
    if mt >= 60 then $oc.css("marginTop", mt ) else $oc.css("marginTop", 30 )

  $(window).on
    resize: ->
      centerOverlay()

  centerOverlay()
