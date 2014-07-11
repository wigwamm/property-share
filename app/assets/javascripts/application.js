// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.widget
//= require jquery.easings
//= require jquery.extensions
//= require jquery.selectBoxIt.min
//= require dropzone
//= require header
//= require parsley
//= require select2
//= require jquery.googlemap
//= require cocoon
//= require bookings
// Global Variables
// $ = jQuery;

// Photo Uploader Variables
window.totalUploadPercent = 0;
window.totalUploadComplete = false;
window.totalImageCount = 0;

$(function() {
  if ($('*[data-googlemap]').length) {
    $('*[data-googlemap]').googleMap();
    return true;
  }
});