class RightmoveProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :portal
  has_many :rightmove_mediums

  field :property_id, type: String
  field :ref, type: String, default: SecureRandom.uuid
  field :publish, type: Boolean, default: true

  validates_presence_of :property_id
  validate :exists

  before_validate :translate_property

  # Upload to Rightmove
  def upload
    data = YAML.load(ERB.new(File.read("#{Rails.root}/lib/rightmove/rightmove.yml")).result)[Rails.env].symbolize_keys!
    json = Hash.new
    create_request_data(data,json)

    delete_empty_hash json.with_indifferent_access

    binding.pry

    send_ssl(json)
  end

  def delete_empty_hash x
    x.is_a?(Hash) ? x.inject({}) do |m, (k, v)|
      m[k] = delete_empty_hash v unless k.blank?
      m
    end : x
  end

  def create_request_data(data, json)
    data.each do |key, value|
      if key == 'required'
        if !value
          return {}
        end
      elsif value.is_a? Hash
        if key == 'fields'
          json = create_request_data(value,{})
        else
          v = create_request_data(value, {})
          json[key] = v if !v.blank?
        end
      else 
        if self.attributes.include? key
          json[key] = self.attributes[key]
        end
      end
    end
    return json
  end

  def send_ssl(data)

    portal = self.portal 
    authentication = portal.portal_authentication

    host = portal.host
    
    send = portal.services['send_property']
    uri = URI.parse(host+send)

    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    p12 = OpenSSL::PKCS12.new(File.read("#{Rails.root}/lib/rightmove/Holmes/Holmes.p12"), "o214e9oY")
    
    https.key = p12.key
    https.cert = p12.certificate

    headers = {"content-type" => "application/json"}
    response = https.post(uri.request_uri,data.to_json,headers)
    
    return response.body
  end


  # # Validation Methods

  def exists
  	requirements = YAML.load(ERB.new(File.read("#{Rails.root}/lib/rightmove/rightmove.yml")).result)[Rails.env].symbolize_keys!
  	exists_recurse(requirements)
  end

  def exists_recurse(reqs)
    reqs.each do |key, value|
      if key == 'required'
        if !value
          return
        end
      elsif value.is_a?(Hash)
        exists_recurse(value)
      else
        if value
          # Check if instance variables exists
          errors.add(:base, "#{key.to_s} is expected") unless self.attributes.keys.include? key
        end
      end
    end
  end

  def translate_property
    property = Property.find(self.property_id)
    agency = property.agent.agency

    self[:network_id] = 7189
    self[:branch_id] = self.portal.branch_id
    self[:channel] =  property.saleorlet #  Sale or Letting - 1 or 2

    # Property Group
    self[:agent_ref] = "#{self.portal.branch_id}_#{self.ref}"
    self[:published] = self.publish
    self[:property_type] = property.property_type
    self[:status] = property.status
    self[:created_at] = Time.now.strftime("%d-%m-%Y %H:%m:%s")
    self[:date_available] = property.date_available.strftime("%d-%m-%Y")

    # Address Group
    self[:house_name_number] = property.street.split(" ").first
    self[:address_2] = property.street.gsub("#{self[:house_name_number]} ","")
    self[:town] = "FUNKY TOWN"
    self[:postcode_1] = property.postcode.match(/[A-Z]{1,2}[0-9]{1,2}/)[0]
    self[:postcode_2] = property.postcode.gsub(self[:postcode_1],"").strip
    self[:display_address] = property.address()

    # Price Group
    self[:price] = property.price.gsub(/[^\d]/, '')
    self[:administration_fees] = agency.administration_fees
    #  If property is for sale
    if self[:channel] == 1
      self[:tenure_type] = property.tenure_type
      self[:tenure_unexpired_years] = property.tenure_unexpired_years
    end

    # Details
    self[:summary] = property.description.truncate(17, separator: ' ')
    self[:description] = property.description
    self[:bedrooms] = property.bedrooms

    # Media
    for img in property.images
      self.rightmove_mediums.build({media_type: 1, media_url: img.photo(:large)})
    end

  end

end