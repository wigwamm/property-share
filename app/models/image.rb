class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3-eu-west-1\.amazonaws\.com\/propertyshare#{!Rails.env.production? ? "\\-#{Rails.env}" : ''}\/(?<path>tmp\/uploads\/.+\/(?<filename>.+))\z}

  field :title, type: String
  field :position, type: Integer
  field :direct_upload_url, type: String
  field :main_image, type: Mongoid::Boolean, default: false
  field :processed, type: Mongoid::Boolean, default: false

  embedded_in :property
  attr_accessor :photo

  before_create :set_upload_attributes

  after_create  :queue_processing

  Paperclip.interpolates :parent_id do |attachment, style|
    attachment.instance._parent.to_param
  end
  Paperclip.interpolates :parent_class do |attachment, style|
    attachment.instance._parent.class
  end

  has_mongoid_attached_file :photo,
    :s3_permissions => :public_read,
    :path => ':parent_class/:parent_id/:attachment/:id/:style/:filename',
    :styles => {
      # :small     => ["560x560",    :jpg],
      :medium    => ["960x960",    :jpg],
      :large     => ["1400x1400>", :jpg],
      :social    => ["1020x1020>", :jpg]
    }

  validates :direct_upload_url, presence: true, format: { with: DIRECT_UPLOAD_URL_FORMAT }
  validates_attachment_presence :photo, :presence => true, :message => "There's no file attached", allow_blank: true
  validates_attachment_size :photo, :in => 0..12.megabytes, :message => "Sorry your image is too large, please add an image less than 12mb", allow_blank: true
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"], :message => "Only jpeg, and png files are allowed property pictures", allow_blank: true

  def main!
    last = self._parent.images.where(main_image: true).first
    main_attrs = { main_image: true }

    self.update_attributes( main_attrs )
    last.update_attribute(:main_image, false ) if last
  end

  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  def post_process_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(photo_content_type).present?
  end

  def self.transfer_and_cleanup(id)
    image = Image.find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(image.direct_upload_url)
    s3 = AWS::S3.new
    if image.post_process_required?
      image.photo = URI.parse(URI.escape(image.direct_upload_url))
    else
      paperclip_file_path = "images/uploads/#{assets_uuid}/#{id}/original/#{direct_upload_url_data[:filename]}"
      s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
    end
 
    image.processed = true
    image.save

    s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
  end

  protected

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    tries ||= 5
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
    s3 = AWS::S3.new
    direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head

    self.photo_file_name     = direct_upload_url_data[:filename]
    self.photo_file_size     = direct_upload_head.content_length
    self.photo_content_type  = direct_upload_head.content_type
    self.photo_updated_at    = direct_upload_head.last_modified

  rescue AWS::S3::Errors::NoSuchKey => e
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
    end
  end

  # Queue file processing
  def queue_processing
    if self.photo_updated_at_changed?
      image_args = { image_id: self.id.to_s, property_id: self._parent.id.to_s }
      Resque.enqueue(PropertyTasks, "property_image_processing", image_args)
      logger.info "ImageProcess enqueued"
    end
  end
end
