$.fn.exchangePositionWith = (selector) ->
    other = $(selector)
    this.after(other.clone())
    other.after(this).remove()

