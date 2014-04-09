class RightmoveProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :portal
  has_many :rightmove_medium

  before_validation :exists, :date_available_format

  # Upload to Rightmove
  def upload
    data = YAML.load(ERB.new(File.read("#{Rails.root}/lib/rightmove.yml")).result)[Rails.env].symbolize_keys!
    json = Hash.new
    create_request_data(data,json)
    json.delete_if { |k, v| v.empty? }

    send_ssl(json)
  end

  def create_request_data(data, json)
    reqs.each do |key, value|
      if key == :required
        if !value
          return {}
        end
      elsif value.is_a? Hash
        if key == :fields
          json = exists(value,{})
        else
          json[key] = exists(value, {})
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

    @portal = Portal.first
    @authentication = @portal.rightmove_authentication

    host = @portal.host
    send = @portal.send_property_url
    uri = URI.parse(host+send)

    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # p12 = OpenSSL::PKCS12.new(File.read("Holmes/Holmes.p12"), "o214e9oY")
    p12 = OpenSSL::PKCS12.new(@portal.pkcs12, @portal.pkcs12_password)
    
    https.key = p12.key
    https.cert = p12.certificate

    headers = {"content-type" => "application/json"}
    response = https.post(uri.request_uri,data.to_json,headers)
    
    return response.body
  end


  # # Validation Methods

  def date_available_format
    date = Time.parse(date_available)
    date_available = date.strftime('dd-MM-yyyy')
  end

  def exists
  	reqs = YAML.load(ERB.new(File.read("#{Rails.root}/lib/rightmove.yml")).result)[Rails.env].symbolize_keys!
  	exists_recurse(reqs)
  end

  def exists_recurse(reqs)
    reqs.each do |key, value|
      if key == :required
        if !value
          return
        end
      elsif value.is_a?(Hash)
        exists(value)
      else
        if value
          # Check if instance variables exists
          if !self.instance_variables.include?(key)
            raise "'"+value.to_s+"' is expected"
          end
        end
      end
    end
  end

end