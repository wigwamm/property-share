class Medium
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :property

  field :media_type,              type: Integer, default: 1
  field :caption,                 type: String
  field :sort_order,              type: Integer

  has_mongoid_attached_file :photo,
    :path           => ":class/:id/:style.:extension",
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, "config", "s3.yml"),
    :url            => ":s3_domain_url",
    :s3_host_name   => "s3-eu-west-1.amazonaws.com",
    :s3_permissions => "public-read",
    :s3_protocol    => "http",
    :styles => {
      :small     => ["560x560",    :jpg],
      :large     => ["1020x1080>", :jpg]
    }

  MEDIA_TYPES = ['Image', 'Floorplan', 'Brochure', 'Virtual Tour', 'Audio Tour', 'EPC', 'EPC Graph']

  validates_attachment_content_type :photo, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"], message: "Only jpeg, gif and png files are allowed for profile pictures"
  validates_attachment_presence :photo, presence: true, message: "There's no file attached"
  validates_attachment_size :photo, in: 0..12.megabytes, message: "Sorry your image is too large, please add an image less than 12mb"

  scope :images, -> { where media_type: 1 }

  def media_url
    photo.url(:large).gsub(/\?\d+/, '')
  end

  def media_update_date
    updated_at.strftime("%d-%m-%Y %H:%M:%S")
  end

  def media_upload_type
    case media_type
    when 1
      'IMG'
    when 2
      'FLP'
    else
      'DOC'
    end
  end
end