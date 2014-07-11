stripeResponseHandler = (status, response) ->
  $form = $(".book-property")
  if response.error
    $form.find(".payment-errors").text response.error.message
    $form.find("input[type=submit]").prop "disabled", false
  else
    token = response.id
    $form.append $('<input type="hidden" name="booking[stripe_token]" />').val(token)
    $form.get(0).submit()

$ ->
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

  $('.book-property').submit (e) ->
    $form = $(this)
    $form.find('input[type=submit]').prop('disabled', true)
    Stripe.card.createToken($form, stripeResponseHandler)
    false
