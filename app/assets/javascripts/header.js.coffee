jQuery ->
  $ = jQuery
  delayTime = 1800
  $home_link = $("#home_link")
  targetH = ""
  completeH = ""
  $header_bar = ""
  propHeight = ""
  $scroll = ""
  propOff = ""

  restore = ($this) ->
    setTimeout ->
      $home_link.text("Made with Property Share")
      $this.children("ul").removeClass("menu_large")
    , delayTime

  setSizes = () -> 
    $header_bar = $("#header_bar")
    $property_title = $header_bar.children(".header_wrapper").children(".property_title")
    targetH = $property_title.children(".actions").offset()
    completeH = $property_title.children(".content").outerHeight(true)

  $(window).on
    resize: ->
      if typeof($header_bar) != "undefined"
        setSizes()
        $header_bar.css("minHeight", completeH)

    scroll: ->
      if typeof($header_bar) != "undefined"
        $scroll = $(this).scrollTop()
        if !$header_bar.hasClass("fixed_top") && $scroll > targetH.top
          $header_bar.css("minHeight", completeH)
          $header_bar.addClass("fixed_top")
        else if $header_bar.hasClass("fixed_top") && $scroll < targetH.top
          $header_bar.removeClass("fixed_top")

  $("#action_button").on
    click: (event) ->
      event.preventDefault()
      $actions_expand = $("#actions_expand")
      $(this).toggleClass("btn_grey")
      $actions_expand.stop().slideToggle 600, "easeOutBack"

  $("#header_expand").on
    click: ->
      $home_link.text("PS")
      $(this).parent("ul").addClass("menu_large")
  $("header").on
    mouseleave: ->
      $this = $(this)
      $ul = $this.children("ul")
      if $ul.hasClass("menu_large")
        restore($this)

  $("#flash").delay(800).slideDown().delay(4000).slideUp()

  if typeof($header_bar) != "undefined"
    setSizes()


