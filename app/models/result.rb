class Result
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :share
  
  field :booked, type: Boolean, default: false
  field :traveled_urls, type: Array, default: []
  field :time_on_site, type: Float, default: 0.0

end
