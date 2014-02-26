class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title,                   type: String
  field :name,                    type: String
  field :aws_random,              type: String
  field :position,                type: Integer
  field :main_image,              type: Boolean, default: false

  attr_accessor :photo
  embedded_in :property, :inverse_of => :images

  before_create :randomise
  # before_save :dev_check_save
  # around_save :dev_check_save_around
  # after_save :dev_check_save_after

  has_mongoid_attached_file :photo,
    :path           => ":class/:id/:style.:extension",
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, "config", "s3.yml"),
    :url            => ":s3_domain_url",
    :s3_host_name   => "s3-eu-west-1.amazonaws.com",
    :s3_permissions => "public-read",
    :s3_protocol    => "http",
    :styles => {
      :small     => ["420x420",    :jpg],
      :large     => ["1920x1680>", :jpg]
    }

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], :message => "Only jpeg, gif and png files are allowed for profile pictures"
  validates_attachment_presence :photo, :presence => true, :message => "There's no file attached"
  validates_attachment_size :photo, :in => 0..12.megabytes, :message => "Sorry your image is too large, please add an image less than 12mb"

  def main!
    # main_attrs = { position: 0, main_image: true }
    # siblings = self.property.images.where(:position => { :$gte => self.position })
    last = self.property.images.where(main_image: true).first
    main_attrs = { main_image: true }

    self.update_attributes( main_attrs )
    last.update_attribute(:main_image, false ) if last
    # siblings.each {|img| img.inc(position: -1) }
  end


  def randomise
    o = [('a'..'z')].map { |i| i.to_a }.flatten
    self.aws_random = o[rand(o.length)]
  end

end