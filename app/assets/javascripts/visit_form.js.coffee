jQuery ->
  $ = jQuery
  console.log "active"
  $buttons = $("#bookings_expand ul").children("a")
  $buttons.on
    click: -> 
      $this = $(this)
      if $this.hasClass( "selected" ) == true
        $buttons.removeClass( "selected" )
        $("#visit_time").val("")
      else
        $buttons.removeClass( "selected" )
        $this.addClass( "selected" )
        $("#visit_availability_id").val($this.data("availabilityid"))
