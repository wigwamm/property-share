jQuery ->
  $ = jQuery
  $buttons = $("#actions_expand ul").children("li")
  btn = $("input#form_btn")
  btnText = "Book Your Visit"
  $mobile = $("input#user_mobile")
  $buttons.on
    click: (event) -> 
      event.preventDefault()
      $this = $(this)
      if $this.hasClass( "selected" ) == true
        $buttons.removeClass( "selected" )
        $mobile.removeClass( "highlight" )
        $("#visit_time").val("")
      else
        $buttons.removeClass( "selected" )
        $this.addClass( "selected" )
        $mobile.addClass( "highlight" )
        $("#visit_availability_id").val($this.data("availabilityid"))
        btn.val( btnText + " @ " + $this.text())
