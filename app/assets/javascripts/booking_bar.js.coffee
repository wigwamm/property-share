$ = jQuery
$bookingBar = $('div#booking_bar')
$availabilities = $('li.availability')
selected = false
$bookingBar.attr('class', 'extended') if $('input#visitor_mobile').is(':focus') or $('input#visitor_mobile').val()

flip_flop = () ->
  $bookingBar.toggleClass('extended') unless $('input#visitor_mobile').is(':focus') or $('input#visitor_mobile').val() or selected

$bookingBar.on
  mouseenter: (e) ->
    console.log 'in we come'
    flip_flop()
  mouseleave: (e) ->
    console.log 'out we go'
    $bookingBar.attr('class','') unless $('input#visitor_mobile').is(':focus') or $('input#visitor_mobile').val() or selected
    # setTimeout flip_flop, 1000

$availabilities.on
  mouseup: (e) ->
    $availabilities.removeClass('selected')
    data = $(this).addClass('selected').data()
    selected = true
    $('#availability_id').val(data.id)
    $('#form_btn').val('Book Viewing @ ' + data.time )
    $('.form .message').text('Please enter your mobile')

    console.log data.id
    console.log data.time
