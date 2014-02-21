jQuery ->
  $ = jQuery
  $("#overlay_cross").on 
    click: -> 
      $(this).parent().fadeOut(800)
    mouseenter: -> 
      $("#overlay").animate
        opacity: 0.85
      , 200
    mouseleave: -> 
      $("#overlay").animate
        opacity: 1
      , 200

