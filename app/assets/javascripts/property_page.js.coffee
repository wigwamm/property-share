jQuery ->
  $ = jQuery

  targetH = ""
  completeH = ""
  $header_bar = ""
  propHeight = ""
  $scroll = ""
  propOff = ""
  $buttons = $("#bookings_expand ul").children("a")
  btn = $("input#form_btn")
  btnText = "Book Your Visit"

  setSizes = () -> 
    $header_bar = $("#header_bar")
    $property_title = $header_bar.children(".header_wrapper").children(".property_title")
    targetH = $property_title.children(".bookings").offset().top
    contentH = $property_title.children(".content").outerHeight(true)

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

  $("#booking_button").on
    click: (event) ->
      event.preventDefault()
      $bookings_expand = $("#bookings_expand")
      $(this).toggleClass("btn_grey")
      $bookings_expand.stop().slideToggle 600, "easeOutBack"


  setSizes()

