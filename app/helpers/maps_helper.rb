module MapsHelper
 
  def google_map_tag(options={})
    
    options.reverse_merge!(width: "100%", height: 600, rough: true, mark_center: true, zoom: 10)

    static_map_tag = image_tag( static_map_url(options), 
                                width: options[:width], 
                                height: options[:height], 
                                alt: "Map for #{options[:address]}"
                                )

    content_tag(:div, static_map_tag, id: options[:id],
      data: {
        googlemap: true,
        size: "#{options[:width]}x#{options[:height]}",
        address: options[:address],
        latlng: options[:latlng],
        marker: true,
        zoom:   options[:zoom],
        rough: options[:rough]
      }
    ).html_safe

  end
 
  def static_map_url(options)
    map_params = [].tap do |p|
      location = options[:address] ? options[:address] : options[:latlng].to_s.gsub(/\[?\]?/, "")
      p << ["size",    "1100x#{options[:height]}"]
      p << ["zoom",    options[:zoom]]
      p << ["center",  location ]
      p << ["markers", location ] if options[:mark_center]
      p << ["maptype", "roadmap"]
      p << ["sensor",  "false"]
    end
 
    "http://maps.google.com/maps/api/staticmap?" + map_params.map { |p| k,v=*p; "#{k}=#{CGI.escape(v.to_s)}"  }.join("&")
  end

  # def google_map_tag(options={})
  #   options.reverse_merge!(width: "100%", height: "100%", rough: true, mark_center: true, zoom: 10)
  #   static_map_tag = image_tag(static_map_url(options), width: options[:width], height: options[:height], alt: "Map for #{options[:address]}")
  #   content_tag(:div, static_map_tag, id: options[:id],
  #     data: {
  #       googlemap: true,
  #       size: "#{options[:width]}x#{options[:height]}",
  #       address: options[:address],
  #       latlng: options[:latlng],
  #       marker: true,
  #       markerimage: "#{image_path('ui/map/rough_map_marker_white.svg')}",
  #       zoom: options[:zoom],
  #       rough: options[:rough]
  #     }
  #   ).html_safe
  # end
 
  # def static_map_url(options)
  #   latlng = options[:latlng].to_s.gsub(/\[?\]?/, "").split(",") if options[:latlng]
  #   map_params = [].tap do |p|
  #     p << ["size",    "1200x800"]
  #     p << ["zoom",    options[:zoom]]
  #     p << ["center",  options[:address]] if options[:address]
  #     p << ["center",  options[:latlng].to_s.gsub(/\[?\]?/, "") ] if options[:latlng]
  #     p << ["markers", options[:address]] if options[:mark_center]
  #     p << ["maptype", "roadmap"]
  #     p << ["sensor",  "false"]
  #   end
 
  #   "http://maps.google.com/maps/api/staticmap?" + map_params.map { |p| k,v=*p; "#{k}=#{v.to_s}"  }.join("&")
  # end
 
 end