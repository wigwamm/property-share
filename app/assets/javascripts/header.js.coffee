jQuery ->
  $ = jQuery
  delayTime = 1800
  $home_link = $("#home_link")
  home_link_text = $home_link.text()
  targetH = ""
  completeH = ""
  $header_wrapper = $("#header_wrapper")
  $prop_wrapper = $('#property_wrapper')
  propHeight = ""
  $scroll = ""
  propOff = ""

  restore = ($this) ->
    setTimeout ->
      $home_link.text(home_link_text)
      $this.children("ul").removeClass("menu_large")
    , delayTime

  setSizes = () -> 
    $header_wrapper = $("#header_wrapper")
    $property_title = $header_wrapper.children(".property_title")
    targetH = $property_title.children(".actions").offset()
    completeH = $header_wrapper.outerHeight(true)
    $header_wrapper.css("height", completeH)
    $prop_wrapper.css("marginTop", completeH)

  setSizes()

  $(window).on
    resize: ->
      if typeof($header_wrapper) != "undefined"
        setSizes()
        $header_wrapper.css("height", completeH)

    scroll: ->
      if typeof($header_wrapper) != "undefined"
        $scroll = $(this).scrollTop()
        if !$header_wrapper.hasClass("fixed_top") && $scroll > targetH.top
          $header_wrapper.css("minHeight", completeH)
          $header_wrapper.addClass("fixed_top")
        else if $header_wrapper.hasClass("fixed_top") && $scroll < targetH.top
          $header_wrapper.removeClass("fixed_top")

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
  
  $(".close_dialog").on
    mouseup: (event) ->
      console.log 'clicked'
      event.preventDefault()
      console.log $(this).data()
      $($(this).data('target')).fadeOut(400)


  # $("#flash").delay(800).slideDown({ duration: 300, easing: 'easeInOutElastic' }, ->

  #   ).delay(4000).slideUp()

  # $("#flash").delay(800).slideDown({ duration: 400, easing: 'easeInOutElastic' }, ->
  #   hold = false
  #   flashCallback = ->
  #     $("#flash").slideUp() unless hold

  #   $("#flash").on 
  #     click: (ev) =>
  #       $("#flash").slideUp()
  #     mouseEnter: (ev) =>
  #       hold = true
  #     mouseLeave: (ev) =>
  #       hold = false

  #   setTimeout flashCallback, 3000
  #   )

  if typeof($header_wrapper) != "undefined"
    setSizes()


