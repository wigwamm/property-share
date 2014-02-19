class Share
  include Mongoid::Document
  include Mongoid::Timestamps

  field :clicked,             type: Boolean, default: false
  field :view_count,          type: Integer, default: 0
  field :to_email,            type: String
  field :to_mobile,           type: String

  belongs_to :property

end
