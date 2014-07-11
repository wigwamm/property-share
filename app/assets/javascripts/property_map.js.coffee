# # jQuery ->
# #   $ = jQuery
# #   propData = $("#map_canvas").data()
# #   console.log propData
# #   # opts =
# #   #   zoom: 10
# #   #   max_zoom: 16
# #   #   scrollwheel: false
# #   #   center: new google.maps.LatLng center.lat(), center.lng()
# #   #   mapTypeId: google.maps.MapTypeId.ROADMAP
# #   #   MapTypeControlOptions:
# #   #       MapTypeIds: [google.maps.MapTypeId.ROADMAP]

# #   initialize = () ->
# #     map_canvas = document.getElementById('map_canvas')
# #     mapOptions =
# #       center: new google.maps.LatLng(propData.lat, propData.lng)
# #       zoom: 8
# #     map = new google.maps.Map(map_canvas)

# #   google.maps.event.addDomListener(window, 'load', initialize)

# console.log "map js loaded"
# $ = jQuery
# $ -> 
#   $.fn.googleMap = () ->
#     element = $(this).get(0)
#     zoomLevel = $(this).data('zoom') || 8

#     if $(this).data('size')
#       [width, height] = $(this).data('size').split('x')
#       $(this).css({width: width, height: height, background: '#fff'})
   
#     wrapperElem = $(this).wrap('<div class="map-wrap"/>').css({background:'#fff'})
#     $(this).hide() # To avoid confusing Flash Of Non-interactive Map Content


#     data = $(this).data()
    
#     latlng = ""
#     if data.address
#       console.log "address"
#       geocoder = new google.maps.Geocoder
#       geocoderParams =
#         address: data.address || "225 N Michigan Ave, Chicago, Illinois, 60601"
#         region: "US"
#       results = geocoder.geocode geocoderParams, (results, status) ->
#         if status == google.maps.GeocoderStatus.OK
#           latlng = results[0].geometry.location
#     if data.latlng
#       console.log "latlng"
#       latlng = new google.maps.LatLng(data.latlng[0], data.latlng[1])

#     mapOptions =
#       mapTypeControl: false
#       overviewMapControl: false
#       zoom: zoomLevel
#       maxZoom: zoomLevel + 1
#       center: latlng
#       draggable: false
#       mapTypeId: google.maps.MapTypeId.ROADMAP
#       scrollwheel: false
#       navigationControl: false
#       mapTypeControl: false

#     console.log "mapOptions", mapOptions
#     map = new google.maps.Map(element, mapOptions)
#     console.log "map", map

#     marker = new google.maps.Marker
#       icon:
#         path: google.maps.SymbolPath.CIRCLE
#         scale: 80
#         fillColor: '#fafafa'
#         fillOpacity: 0.7
#         strokeColor: '#F5A156'
#         strokeWeight: 2
#         draggable: false
#       position: latlng
#       map: map

#     $(this).show() # Time to re-show the element