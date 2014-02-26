jQuery ->
  $ = jQuery
  $availabilitySelect = $(".availability_select")
  $availabilityTime = $("input#availability_time")
  $availabilitySelect.selectBoxIt()
  $availabilitySelect.on
    change: ->
      $availabilityTime.val("09:00")
  $availabilityTime.focusout ->
    unless this.value[1] == ":" && this.length > 3
      n = this.value.replace(/\:/g, "").split("")
      n[1] = n[1] + ":"
      this.value = n.join("")

