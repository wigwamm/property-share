$.fn.googleMap = () ->
  element = $(this).get(0)
  zoomLevel = $(this).data('zoom') || 8

  if $(this).data('size')
    [width, height] = $(this).data('size').split('x')
    $(this).css({width: width, height: height, background: '#fff'})
 
  wrapperElem = $(this).wrap('<div class="map-wrap"/>').css({background:'#fff'})

  $(this).hide() # To avoid confusing Flash Of Non-interactive Map Content

  data = $(this).data()
  
  latlng = ""
  if data.address
    geocoder = new google.maps.Geocoder
    geocoderParams =
      address: data.address || "225 N Michigan Ave, Chicago, Illinois, 60601"
      region: "US"
    results = geocoder.geocode geocoderParams, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        latlng = results[0].geometry.location
  if data.latlng
    latlng = new google.maps.LatLng(data.latlng[0], data.latlng[1])

  mapOptions =
    mapTypeControl: false
    overviewMapControl: false
    zoom: zoomLevel
    maxZoom: zoomLevel + 1
    center: latlng
    draggable: false
    mapTypeId: google.maps.MapTypeId.ROADMAP
    scrollwheel: false
    navigationControl: false
    mapTypeControl: false

  map = new google.maps.Map(element, mapOptions)

  marker = new google.maps.Marker
    icon:
      path: google.maps.SymbolPath.CIRCLE
      scale: 80
      fillColor: '#fafafa'
      fillOpacity: 0.7
      strokeColor: '#F5A156'
      strokeWeight: 2
      draggable: false
    position: latlng
    map: map

  $(element).show() # Time to re-show the element
