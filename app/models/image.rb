class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title,                type: String
  field :aws_random,              type: String

  attr_accessor :photo
  embedded_in :property, :inverse_of => :images

  before_save :mock_title
  before_create :randomise

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

  def mock_title
    self.title = self.photo_file_name.split('.')[0..-2].join(".")
  end

  def randomise
    o = [('a'..'z')].map { |i| i.to_a }.flatten
    self.aws_random = o[rand(o.length)]
  end

end