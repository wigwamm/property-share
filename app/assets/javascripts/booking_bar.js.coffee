$ = jQuery
$bookingBar = $('div#booking_bar')
$availabilities = $('li.availability')
selected = false
$dates = $('#actions_expand ul').children('li')
btn = $('input#form_btn')
btnText = 'Book Your Visit'
$mobile_input = $('input#visitor_mobile')

$bookingBar.attr('class', 'extended') if $('input#visitor_mobile').is(':focus') or $('input#visitor_mobile').val()

flip_flop = () ->
  # $bookingBar.toggleClass('extended') unless $('input#visitor_mobile').is(':focus') or $('input#visitor_mobile').val() or selected

# $bookingBar.on
#   mouseenter: (e) ->
#     console.log 'in we come'
#     flip_flop()
#   mouseleave: (e) ->
#     console.log 'out we go'
#     $bookingBar.attr('class','') unless $('input#visitor_mobile').is(':focus') or $('input#visitor_mobile').val() or selected
#     # setTimeout flip_flop, 1000

$twin = ''
active = false

$availabilities.on
  click: (e) ->
    $this = $(this)
    $this.siblings().removeClass('selected')
    $twin.addClass('selected')
    data = $this.addClass('selected').data()
    selected = true
    $('#availability_id').val(data.id)
    $('#form_btn').val('Book Viewing @ ' + data.time )
    $('.form .message').text('Please enter your mobile')
    $mobile_input.addClass( 'highlight' ).focus()
    console.log data.id
    console.log data.time

  mouseenter: ->
    $twin = $($(this).attr('class').replace('availability ', 'li.'))
    $twin.addClass('joint_hover')
  mouseleave: ->
    $twin.removeClass('joint_hover')

$('.hover').on
  click: (e) ->
    active = true
    console.log 'clicked'
    $bookingBar.addClass('extended')
    $('ol.calendar2').addClass('targeted').children('li').removeClass('expand')
    $('#targeted_day .calendar_new').html($(this).parent('li').clone(true, true).addClass('expand'))

$mobile_input.on
  blur: (e) ->
    unless $(this).val() or active == true
      # $('#targeted_day .calendar_new').html('')
      $('ol.calendar2').removeClass('targeted')
      $bookingBar.removeClass('extended')

  ########################################################
  #####     Jquery Validator 
  
  $.validator.addMethod 'mobile', (value, element) ->
    return this.optional(element) || /(\+|\d)[0-9]{7,16}/g.test(value)
  , 'Not a valid mobile'

  error_message = (object, target) ->
    formErrors = object.numberOfInvalids()
    target = $(target)
    if formErrors
      message = if formErrors == 1 then '<p>' + object.errorList[0].message + '</p>' else '<p>Please fill in the form correctly, there\'s ' + formErrors + ' errors</p>';
      target.html(message)
      target.slideDown()
    else
      target.slideUp()

  propertyValidator = $('#visits-form').validate
    debug: false
    ignore: []
    errorElement: 'p'
    wrapper: 'div'
    errorClass: 'error'
    focusout: true
    rules:
      'visit[visitor_attributes][mobile]':
        required: true
    messages:
      'visit[visitor_attributes][mobile]':
        required: "You're missing your mobile"

    errorPlacement: (label, element) ->
      label.addClass('error_message')
      # label.insertAfter(element)
    
    highlight: (element, errorClass, validClass) ->
      $element = $(element)
      if $element.data('highlight')
        $($element.data('highlight')).addClass(errorClass + ' invalid').removeClass(validClass)
      else
        $element.addClass(errorClass + ' invalid').removeClass(validClass)
    
    unhighlight: (element, errorClass, validClass) ->
      $element = $(element)
      if $element.data('highlight')
        $($element.data('highlight')).removeClass(errorClass + ' invalid').addClass(validClass)
      else
        $element.removeClass(errorClass + ' invalid').addClass(validClass)
      error_message(propertyValidator, 'div.error_messages')
    
    invalidHandler: (event, validator) ->
      error_message(validator, '.form .message')

    submitHandler: (form) ->
      console.log "submitting"
      form.submit()
      # $.rails.handleRemote( $(form) ) # for ajax forms
