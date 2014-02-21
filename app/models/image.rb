class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title,              type: String

  attr_accessor :photo
  embedded_in :property, :inverse_of => :images

  @o = [('a'..'z')].map { |i| i.to_a }.flatten
  before_save :mock_title

  has_mongoid_attached_file :photo,
    :path           => "#{@o[rand(@o.length)]}/:class/:id/:style.:extension",
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, "config", "s3.yml"),
    :url            => ":s3_domain_url",
    :s3_host_name   => "s3-eu-west-1.amazonaws.com",
    :s3_permissions => "public-read",
    :s3_protocol    => "http",
    :styles => {
      :thumb     => ["100x100",   :jpg],
      :small     => ["420x420",    :jpg],
      :medium    => ["960x960>",   :jpg],
      :large     => ["1920x1680>", :jpg]
    }

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], :message => "Only jpeg, gif and png files are allowed for profile pictures"
  validates_attachment_presence :photo, :presence => true, :message => "There's no file attached"
  validates_attachment_size :photo, :in => 0..12.megabytes, :message => "Sorry your image is too large, please add an image less than 12mb"

  def mock_title
    self.title = self.photo_file_name.split('.')[0..-2]
  end

end