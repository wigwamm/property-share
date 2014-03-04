jQuery ->
  $ = jQuery
  $bookings = $("#header_bar").children(".property_title").children(".bookings").offset()
  $contentH = $("#header_bar").children(".property_title").children(".content").outerHeight()
  $header_bar = $("#header_bar")

  $(window).on
    scroll: ->
      $scroll = $(this).scrollTop()

      if !$header_bar.hasClass("fixed_top") && $scroll > $bookings.top
        $header_bar.css("minHeight", $contentH)
        $header_bar.addClass("fixed_top")

      else if $header_bar.hasClass("fixed_top") && $scroll < $bookings.top
        $header_bar.removeClass("fixed_top")

    resize: ->
      $bookings = $("#header_bar").children(".property_title").children(".bookings").offset()
      $contentH = $("#header_bar").children(".property_title").outerHeight(true)
      $header_bar = $("#header_bar")
      $header_bar.css("minHeight", $contentH)

  $("#booking_button").on
    click: ->
      $bookings_expand = $("#bookings_expand")
      $bookings_expand.css(top: $contentH).slideDown()