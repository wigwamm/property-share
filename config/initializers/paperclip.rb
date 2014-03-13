Paperclip.interpolates :assets_uuid do |attachment, style|
  attachment.assets_uuid
end

Paperclip::Attachment.default_options.merge!(
  url:                  ':s3_domain_url',
  path:                 ':class/:assets_uuid/:attachment/:id/:style/:filename',
  storage:              :s3,
  s3_credentials:       Rails.configuration.aws,
  s3_permissions:       :private,
  s3_protocol:          'http',
  s3_host_name:         's3-eu-west-1.amazonaws.com'
)