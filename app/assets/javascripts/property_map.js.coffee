# jQuery ->
#   $ = jQuery
#   propData = $("#map_canvas").data()
#   console.log propData
#   # opts =
#   #   zoom: 10
#   #   max_zoom: 16
#   #   scrollwheel: false
#   #   center: new google.maps.LatLng center.lat(), center.lng()
#   #   mapTypeId: google.maps.MapTypeId.ROADMAP
#   #   MapTypeControlOptions:
#   #       MapTypeIds: [google.maps.MapTypeId.ROADMAP]

#   initialize = () ->
#     map_canvas = document.getElementById('map_canvas')
#     mapOptions =
#       center: new google.maps.LatLng(propData.lat, propData.lng)
#       zoom: 8
#     map = new google.maps.Map(map_canvas)

#   google.maps.event.addDomListener(window, 'load', initialize)
jQuery ->
  $ = jQuery
  $.fn.googleMap = () ->
    element = $(this).get(0)
    zoomLevel = $(this).data('zoom') || 8
   
    if $(this).data('size')
      [width, height] = $(this).data('size').split('x')
      $(this).css({width: Number(width), height: Number(height), background: '#fff'})
   
    wrapperElem = $(this).wrap('<div class="map-wrap"/>').css({background:'#fff'})
    $(this).hide() # To avoid confusing Flash Of Non-interactive Map Content
   
    if $(this).data('address')
      geocoder = new google.maps.Geocoder
      geocoderParams =
        address: $(this).data('address') || "231 Lavender Hill, London, SW11 1JR"
        region: "UK"
      results = geocoder.geocode geocoderParams, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          latlng = results[0].geometry.location
    if $(this).data('lnglat')
        latlng = $(this).data('lnglat')
        
        mapOptions =
          mapTypeControl: false
          overviewMapControl: false
          zoom: zoomLevel
          center: latlng
          draggable: false
          mapTypeId: google.maps.MapTypeId.ROADMAP
   
        map = new google.maps.Map(element, mapOptions)
   
        marker = new google.maps.Marker
          position: latlng
          map: map
   
        $(element).show() # Time to re-show the element