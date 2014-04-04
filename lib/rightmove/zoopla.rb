require 'nokogiri'
require 'open-uri'
# require 'mongoid'
require 'unirest'
require 'yaml'

require 'openssl'
require 'socket'
require 'net/http'
require 'uri'
require 'json'
require 'blm'
require 'pry'

class ZooplaClient

	def intialize

	end


	def post_ssl(data)

		host = self.config['development']['host']
		send = self.config['default']['send_prop']
		url = host+send
		uri = URI.parse(url)

		headers = {'Accept' => 'application/json'} #, "username" => "rightmove", "password" => "rightpass"}

		request = Net::HTTP.new(uri.host,uri.port)
		request.use_ssl = true
		request.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request.ca_file = File.open("Holmes/Holmes.pem").read

		binding.pry

		response = request.post(uri.request_uri,data.to_json,headers)

		binding.pry

		puts response.body		

		

		return response.body

	end


	# BLM

	def create_header_section(property_count=nil, eof=nil, eor=nil)

		header = "#HEADER#\n"
		header += "Version : 3\n"
		header += "EOF : '^'\n"
		header += "EOR : '~'\n"
		if !property_count.nil? 
			header += "Property Count : "+property_count.to_s+"\n" 
		end

		header += "Generated Date : "+Time.now.strftime("%d-%M-%Y %H:%M")+"\n"
		return header
	end

	def create_data_definition_section(zoopla_model)
		description = "#DEFINITION#\n"
		zoopla_model.each do |key, value|
			description +=key.to_s+"^"
		end
		description+="~"
	end

	def create_data_section(zoopla_model)

		data = "#DATA#\n"
		zoopla_model.each do |key, value|
			data +=value.to_s+"^"
		end

	end

end
