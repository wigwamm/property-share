jQuery ->
  $ = jQuery
  delayTime = 1800
  $home_link = $("#home_link")
  restore = ($this) ->
    setTimeout ->
      $home_link.text("Made with Property Share")
      $this.parent("ul").removeClass("menu_large")
    , delayTime
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