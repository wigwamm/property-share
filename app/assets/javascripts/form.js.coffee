jQuery ->
  $ = jQuery
  $(".availability_select").selectBoxIt()
  console.log ($("input#availability_time").val())
  $("input#availability_time").focusout ->
    console.log this.value
    unless this.value[1] == ":" && this.length > 3
      n = this.value.replace(/\:/g, "").split("")
      n[1] = n[1] + ":"
      this.value = n.join("")

