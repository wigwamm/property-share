jQuery ->
  $ = jQuery

  $(".select_availability").on "keyup paste focusout", ->
      $("#preview_property_title").text this.value
      $("input#property_url").val urlify(this.value)

  $("textarea#property_description").on "keyup paste focusout", ->
      $("#preview_property_description").text this.value

  $("input#property_postcode").on "focusout", ->
    if this.value.length >= 5
      $("#preview_property_map").stop().animate
        height: "60px",
        opacity: 1
      , 600, "easeInOutElastic"

