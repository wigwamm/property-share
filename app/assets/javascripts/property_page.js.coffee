jQuery ->
  $ = jQuery

  targetH = ""
  completeH = ""
  $header_bar = ""

  setSizes = () -> 
    $header_bar = $("#header_bar")
    targetH = $header_bar.children(".property_title").children(".bookings").offset().top
    contentH = $header_bar.children(".property_title").children(".content").outerHeight(true)

  setSizes()

  $(window).on
    resize: ->
      setSizes()
      $header_bar.css("minHeight", completeH)

    scroll: ->
      $scroll = $(this).scrollTop()
      if !$header_bar.hasClass("fixed_top") && $scroll > targetH
        $header_bar.css("minHeight", completeH)
        $header_bar.addClass("fixed_top")
      else if $header_bar.hasClass("fixed_top") && $scroll < targetH
        $header_bar.removeClass("fixed_top")

  $("#booking_button").on
    click: ->
      $bookings_expand = $("#bookings_expand")
      $bookings_expand.css(top: $contentH).slideDown()