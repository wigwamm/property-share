require 'open-uri'
require 'yaml'
require 'openssl'
require 'socket'
require 'net/http'
require 'uri'
require 'json'
require 'singleton'


class Rightmove

  include Singleton
  include Rails.application.routes.url_helpers

  def initialize
    @rightmove_config = YAML.load(File.read("#{Rails.root}/config/rightmove_direct_upload.yml"))[Rails.env].symbolize_keys!
    @key_data = YAML.load(File.read("#{Rails.root}/lib/rightmove/data_format.yml"))[Rails.env].symbolize_keys!
    @host_name = YAML.load(File.read("#{Rails.root}/config/secrets.yml"))[Rails.env].symbolize_keys![:host_name]
  end

  def list
    @property = nil
    @channel = 2
    response = post :list

    if response.code == '200'
      JSON.parse(response.body)
    else
      {"message"=>"Error while fetching from Rightmove", "success"=>false} 
    end
  end

  def add(property_id)
    @property = Property.find(property_id)
    @property.branch_id = @rightmove_config[:branch_id]
    @channel = @property.trans_type_id
    response = post :send
    parsed = JSON.parse(response.body)

    if response.code == '200'
      JSON.parse(response.body)
    else
      {"message"=>"Error while uploading to Rightmove", "success"=>false} 
    end
  end

  def remove(property_id)
    @property = Property.find(property_id)
    @property.branch_id = @rightmove_config[:branch_id]
    @channel = @property.trans_type_id
    response = post :remove
    parsed = JSON.parse(response.body)

    if response.code == '200'
      JSON.parse(response.body)
    else
      {"message"=>"Error while removing from Rightmove", "success"=>false} 
    end
  end

  def post(action)
    post_data = { 
      network: { network_id: @rightmove_config[:network_id] },
      branch: { branch_id: @rightmove_config[:branch_id], channel: @channel }
    }
    post_data = post_data.merge(send("#{action.to_s}_data"))
    puts post_data if Rails.env.development?

    post_data[:branch][:overseas] = false if action == :send

    prop = "#{action.to_s}_prop".to_sym
    uri = URI.parse("#{@rightmove_config[:host]}#{@rightmove_config[prop]}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    p12 = OpenSSL::PKCS12.new(File.read("#{Rails.root}/lib/rightmove/Holmes/Holmes.p12"), "o214e9oY")
    https.key = p12.key
    https.cert = p12.certificate

    headers = {"content-type" => "application/json"}

    response = https.post(uri.request_uri, post_data.to_json, headers)
  end

  def list_data
    {}
  end

  def send_data
    post_data = create_request_data(@key_data, @property)
    post_data[:property]['media'] << {'media_type' => 3, 'media_url' => Rails.application.routes.url_helpers.property_url(@property, host: @host_name), 'caption' => "Super Size Images"}
    post_data
  end

  def remove_data
    { property: { agent_ref: @property.agent_ref } }
  end  

  def create_request_data(data, obj)
    ret = {}

    data.each do |key, value|
      if value.is_a? Hash
        new_key = key == 'details' ? 'detail' : key
        obj = @property.send new_key if Property::ASSOCIATIONS.include? key
        obj = obj.send new_key if key == 'rooms'

        if obj.is_a? Array
          ret[key] = []

          obj.each do |o|
            v = create_request_data(value, o)
            ret[key] << v unless v.blank?
          end
        else
          v = create_request_data(value, obj)
          ret[key] = v unless v.blank?
        end
      else 
        if obj.respond_to? key
          v =  obj.send key 
          ret[key] = v unless v.blank?
        end
      end
    end
    
    ret
  end
end