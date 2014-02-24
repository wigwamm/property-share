class AnalyticsCookie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type_is,           type: String, default: "unknown"  # define user, agent, sharee, random 
  field :subject_id,        type: String  # if user || agent record id
  field :origin_url,        type: String  # landing url
  field :share_id,          type: String  # define user, agent, sharee, random 
  field :path,              type: Array  # << append on pages gone afterwards 
  field :booked,            type: Boolean, default: false  # set to true if the new 'user' has booked a visit

end
