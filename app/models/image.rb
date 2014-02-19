class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :property_id, type: Integer

  attr_accessor :file

  embedded_in :property, :inverse_of => :images
  has_mongoid_attached_file :file
end