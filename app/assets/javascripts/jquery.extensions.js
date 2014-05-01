$.fn.exchangePositionWith = function(selector) {
    var other = $(selector);
    this.after(other.clone());
    other.after(this).remove();
};