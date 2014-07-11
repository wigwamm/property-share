module MapsHelper
 
  def google_map_tag(options={})
    options.reverse_merge!(width: "100%", height: 500, rough: true, mark_center: true, zoom: 10)
    static_map_tag = image_tag(static_map_url(options), width: options[:width], height: options[:height], alt: "Map for #{options[:address]}")
    content_tag(:div, static_map_tag, id: options[:id],
      data: {
        googlemap: true,
        size: "#{options[:width]}x#{options[:height]}",
        address: options[:address],
        latlng: options[:latlng],
        marker: true,
        markerimage: "#{image_path('ui/map/rough_map_marker_white.svg')}",
        zoom: options[:zoom],
        rough: options[:rough]
      }
    ).html_safe
  end
 
  def static_map_url(options)
    latlng = options[:latlng].split(",") if options[:latlng]
    map_params = [].tap do |p|
      p << ["size",    "1000x600"]
      p << ["zoom",    options[:zoom]]
      p << ["center",  options[:address]] if options[:address]
      p << ["center",  "#{latlng[0]},#{latlng[1]}" ] if options[:latlng]
      p << ["markers", options[:address]] if options[:mark_center]
      p << ["maptype", "roadmap"]
      p << ["sensor",  "false"]
    end
 
    "http://maps.google.com/maps/api/staticmap?" + map_params.map { |p| k,v=*p; "#{k}=#{CGI.escape(v.to_s)}"  }.join("&")
  end
 
end