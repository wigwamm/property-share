jQuery ->
  $ = jQuery
  $buttons = $("li.toggle")
  $buttons.on
    click: -> 
      $this = $(this)
      if $this.hasClass( "active" ) == true
        $buttons.removeClass( "active" ).addClass( "disactive" )
        $("#visit_time").val("")
      else
        $buttons.removeClass( "active" ).addClass( "disactive" )
        $this.removeClass( "disactive" ).addClass( "active" )
        $("#visit_availability_id").val($this.data("availabilityid"))
