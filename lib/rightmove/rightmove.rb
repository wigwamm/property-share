require 'nokogiri'
require 'open-uri'
# require 'mongoid'
require 'yaml'

require 'openssl'
require 'socket'
require 'net/http'
require 'uri'
require 'json'

require 'pry'


class RightmoveClient

	attr_accessor :debug, :config

	def initialize
		# super
		loadConfig
	end

	def loadConfig

		self.config = YAML.load(File.read('rightmove_config.yml'))
		# self.config = YAML.load(ERB.new(File.read("#{Rails.root}/lib/rightmove_config.yml")).result)[Rails.env].symbolize_keys!
	end

	def post_property(property_id,agent_id)

		property = Property.where(_id: property_id)
		agent = Agent.where(_id: agent_id)

		network_id = self.config[:development][:network_id]
		branch_id = self.config[:development][:branch_id]

		# Property
		# agent_ref = "Agent"
		# published
		# property_type
		# status
		# new_home=nil
		# student_property=nil
		# house_flat_share=nil
		# create_date=nil
		# update_date=nil
		# date_available=nil
		# contract_months=nil
		# minimum_term=nil
		# let_type=nil)

		binding.pry
	end

	def test_remove_property
		data = {}

		# Network
		network_id = self.config['default']['network_id']
		# Branch
		branch_id = config['default']['branch_id']
		channel = 2 # sale

		# Property
		agent_ref = branch_id.to_s+'_Test1'
		removal

	end

	def test_send_property

		data = {}

		# Network
		network_id = self.config['default']['network_id']
		# Branch
		branch_id = config['default']['branch_id']
		channel = 2 # sale
		# Property
		agent_ref = branch_id.to_s+'_Test1'
		published = true
		property_type = 1 # Terraced House
		status = 1 # Available
		# Address
		house_name_number = "231"
		town = "Battersea"
		postcode1 = "SW11"
		postcode2 = "1JR"
		display_address = "Lavender Hill, Battersea, London, SW11 1JR"
		# Price
		price = 1256
		# Details
		summary = "This is a lovely house"
		description =  "It has things in it"
		bedrooms = 3
		# Media
		media_type = 1
		media_url = "http://www.google.co.uk"
		# Principal
		principal_email_address = "max@wigwamm.com"


		# Create groups
		network = create_network_group(network_id)
		branch = create_branch_group(branch_id, channel)
		property = create_property_group(agent_ref, published, property_type, status)
		
		# Within property - address, price, room
		address = create_address_group(house_name_number, town, postcode1, postcode2, display_address)
		price = create_price_information_group(price)
		details = create_details_group(summary, description, bedrooms)
		media = []
			# Add media
			media.push create_media(1, "http://goo.gl/HjR9MF", "Picture")
			media.push create_media(2, "http://www.7233bruno.com/downloads/floorplan.gif", "Flooplan")
			media.push create_media(3, "http://www.google.com", "Brochure")
			media.push create_media(4, "http://www.facebook.com", "Virtual Tour")
			media.push create_media(5, "http://www.soundcloud.com ", "Audio Tour")
			media.push create_media(6, "http://www.britishgas.co.uk", "EPC")
			media.push create_media(7, "http://www.ringley.co.uk/images/EPC1.gif", "EPC Graph")
		principal = create_principal_group(principal_email_address)
		property[:address] = address
		property[:price_information] = {"price"=>1235} # don't know why not working properly
		property[:details] = details
		property[:media] = media
		property[:principal] = principal

		data[:network] = network
		data[:branch] = branch
		data[:property] = property

		post_ssl(data)

	end

	# Data is a hash
	def post_ssl(data)

		host = self.config['development']['host']
		send = self.config['default']['send_prop']
		url = host+send
		uri = URI.parse(url)

		https = Net::HTTP.new(uri.host,uri.port)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER

		# OpenSSL::X509::Certificate.new(File.read("Holmes/Holmes.pem"))

		p12 = OpenSSL::PKCS12.new(File.read("Holmes/Holmes.p12"), "o214e9oY")
		
		https.key = p12.key
		https.cert = p12.certificate

		headers = {"content-type" => "application/json"}

		binding.pry

		# request.ca_file = File.open("Holmes/Holmes.pem")

		response = https.post(uri.request_uri,data.to_json,headers)

		binding.pry

		puts response.body		

		

		return response.body

	end

	###
	##    JSON FORMATTER
	###

	# Generic

	def create_network_group(network_id)
		return {:network_id => network_id}
	end

	def create_branch_group(branch_id, channel, overseas=nil)
		branch_data = {}

		branch_data[:branch_id] = branch_id 
		branch_data[:channel] = channel 
		branch_data[:overseas] = overseas  if overseas

		return branch_data
	end

	# SendProperty Methods

	def create_property_group( agent_ref, published, property_type, status, new_home=nil, student_property=nil, create_date=nil, update_date=nil, date_available=nil, contract_months=nil, minimum_term=nil, let_type=nil)

		property_data = {}

		property_data[:agent_ref] = agent_ref 
		property_data[:published] = published 
		property_data[:property_type] = property_type 
		property_data[:status] = status 
		property_data[:new_home] = new_home  if new_home
		property_data[:student_property] = student_property  if student_property
		property_data[:create_date] = create_date  if create_date
		property_data[:update_date] = update_date  if update_date
		property_data[:date_available] = date_available  if date_available
		property_data[:contract_months] = contract_months  if contract_months
		property_data[:minimum_term] = minimum_term  if minimum_term
		property_data[:let_type] = let_type  if let_type

		return property_data

	end

	def create_principal_group (principal_email_address,auto_email_when_live=nil,auto_email_updates=nil)

		principal_data = {}

		principal_data[:principal_email_address] = principal_email_address 
		principal_data[:auto_email_when_live] = auto_email_when_live  if auto_email_when_live
		principal_data[:auto_email_updates] = auto_email_updates  if auto_email_updates

		return principal_data

	end


	def create_address_group( house_name_number, town, postcode1, postcode2, display_address, address2=nil, address3=nil, address4=nil, lonlat=nil, pov=nil)

		address_data = {}

		address_data[:house_name_number] = house_name_number 
		address_data[:address2] = address2  if address2
		address_data[:address3] = address3  if address3
		address_data[:address4] = address4  if address4
		address_data[:town] = town 
		address_data[:postcode_1] = postcode1 
		address_data[:postcode_2] = postcode2 
		address_data[:display_address] = display_address 
		address_data[:longitude] = lonlat[0]  if (!lonlat.nil? && lonlat.count == 2 && lonlat.is_a?(Array))
		address_data[:latitude] = lonlat[1]  if (!lonlat.nil? && lonlat.count == 2 && lonlat.is_a?(Array))
		address_data[:pov_latitude] = pov[0]  if (!pov.nil? && pov.count == 5 && pov.is_a?(Array))
		address_data[:pov_longitude] = pov[1] if (!pov.nil? && pov.count == 5 && pov.is_a?(Array))
		address_data[:pov_pitch] = pov[2] if (!pov.nil? && pov.count == 5 && pov.is_a?(Array))
		address_data[:pov_heading] = pov[3] if (!pov.nil? && pov.count == 5 && pov.is_a?(Array))
		address_data[:pov_zoom] = pov[4] if (!pov.nil? && pov.count == 5 && pov.is_a?(Array))

		return address_data

	end

	def create_price_information_group( price, price_qualifier=nil, deposit=nil, amdinistration_fee=nil, rent_frequency=nil, tenure_type=nil, auction=nil, tenure_unexpired_years=nil, price_per_unit_area=nil)
		
		price_data = {}

		price_data[:price] = price 
		price_data[:price_qualifier] = price_qualifier  if price_qualifier
		price_data[:deposit] = deposit  if deposit
		price_data[:price_data] = price_data  if price_data
		price_data[:rent_frequency] = rent_frequency  if rent_frequency
		price_data[:tenure_type] = tenure_type  if tenure_type
		price_data[:auction] = auction  if auction
		price_data[:tenure_unexpired_years] = tenure_unexpired_years  if tenure_unexpired_years
		price_data[:price_per_unit_area] = price_per_unit_area  if price_per_unit_area

		return price_data

	end

	def create_details_group(summary, description, bedrooms, features=nil,bathrooms=nil,reception_rooms=nil,parking=nil,outside_space=nil,year_built=nil,internal_area=nil,internal_area_unit=nil,land_area=nil,land_area_unit=nil,floors=nil,entrance_floor=nil,condition=nil,accessibility=nil,heating=nil,furnished_type=nil,pets_allowed=nil,smokers_considered=nil,housing_benefit_considered=nil,sharers_considered=nil,burglar_alarm=nil,washing_machine=nil,dishwasher=nil,all_bills_inc=nil,water_bill_inc=nil,gas_bill_inc=nil,electricity_bill_inc=nil,tv_licence_inc=nil,sat_cable_tv_bill_inc=nil,internet_bill_inc=nil,business_for_sale=nil,comm_use_class=nil)

		details_data = {}

		details_data[:summary] = summary 
		details_data[:description] = description 
		details_data[:bedrooms] = bedrooms 
		details_data[:features] = features  if features
		details_data[:bedrooms] = bedrooms  if bedrooms
		details_data[:reception_rooms] = reception_rooms  if reception_rooms
		details_data[:parking] = parking  if parking
		details_data[:outside_space] = outside_space  if outside_space
		details_data[:year_built] = year_built  if year_built
		details_data[:internal_area_unit] = internal_area_unit  if internal_area_unit
		details_data[:land_area] = land_area  if land_area
		details_data[:land_area_unit] = land_area_unit  if land_area_unit
		details_data[:floors] = floors  if floors
		details_data[:entrance_floor] = entrance_floor  if entrance_floor
		details_data[:condition] = condition  if condition
		details_data[:accessibility] = accessibility  if accessibility
		details_data[:heating] = heating  if heating
		details_data[:furnished_type] = furnished_type  if furnished_type
		details_data[:pets_allowed] = pets_allowed  if pets_allowed
		details_data[:smokers_considered] = smokers_considered  if smokers_considered
		details_data[:housing_benefit_considered] = housing_benefit_considered  if housing_benefit_considered
		details_data[:sharers_considered] = sharers_considered  if sharers_considered
		details_data[:smokers_considered] = smokers_considered  if smokers_considered
		details_data[:burglar_alarm] = burglar_alarm  if burglar_alarm
		details_data[:washing_machine] = washing_machine  if washing_machine
		details_data[:dishwasher] = dishwasher  if dishwasher
		details_data[:all_bills_inc] = all_bills_inc  if all_bills_inc
		details_data[:water_bill_inc] = water_bill_inc  if water_bill_inc
		details_data[:gas_bill_inc] = gas_bill_inc  if gas_bill_inc
		details_data[:electricity_bill_inc] = electricity_bill_inc  if electricity_bill_inc
		details_data[:tv_licence_inc] = tv_licence_inc  if tv_licence_inc
		details_data[:sat_cable_tv_bill_inc] = sat_cable_tv_bill_inc  if sat_cable_tv_bill_inc
		details_data[:internet_bill_inc] = internet_bill_inc  if internet_bill_inc
		details_data[:business_for_sale] = business_for_sale  if business_for_sale
		details_data[:comm_use_class] = comm_use_class  if comm_use_class

		return details_data
	end

	def create_rooms_group(room_name, room_description=nil, room_length=nil, room_width=nil, room_dimension_unit=nil, room_photo_urls=nil)
		rooms_data = {}

		rooms_data[:room_name] = room_name 
		rooms_data[:room_description] = room_description  if room_description
		rooms_data[:room_length] = room_length  if room_length
		rooms_data[:room_width] = room_width  if room_width
		rooms_data[:room_dimension_unit] = room_dimension_unit  if room_dimension_unit
		rooms_data[:room_photo_urls] = room_photo_urls  if room_photo_urls

		return rooms_data

	end

	def create_media(media_type, media_url, caption=nil, sort_order=nil, media_update_date=nil)

		media = {}

		media[:media_type] = media_type 
		media[:media_url] = media_url 
		media[:caption] = caption  if caption
		media[:sort_order] = sort_order  if sort_order
		media[:media_update_date] = media_update_date  if media_update_date

		return media

	end

	# SendProperty - alternate

	def sendProperty(rmm)
		
		data = { :network => 
					{:network_id => rmm[:network_id]}, 
				:branch => 
					{:branch_id => rmm[:branch_id], :channel => rmm[:channel], :overseas => rmm[:overseas]},		:property => {:agent_ref => rmm[:agent_ref], :published => rmm[:published], :property_type => rmm[:property_type], :status => rmm[:status], :new_home => rmm[:new_home], :student_property => rmm[:student_property], :create_date => rmm[:create_date], :update_date => rmm[:update_date], :date_available => rmm[:date_available], :contract_months => rmm[:contract_months], :minimum_term => rmm[:minimum_term], :let_type => rmm[:let_type],							:address => {:house_name_number => rmm[:house_name_number], :address_2 => rmm[:address_2], :address_3 => rmm[:address_3], :address_4 => rmm[:address_4], :town => rmm[:town], :postcode_1 => rmm[:postcode_1], :postcode_2 => rmm[:postcode_2], :display_address => rmm[:display_address],
			:latitude => rmm[:latitude],
			:longitude => rmm[:longitude],
			:pov_latitude => rmm[:pov_latitude],
			:pov_longitude => rmm[:pov_longitude],
			:pov_pitch => rmm[:pov_pitch],
			:pov_heading => rmm[:pov_heading],
			:pov_zoom => rmm[:pov_zoom]}, 						:price_information => {:price => rmm[:price],:price_qualifier => rmm[:price_qualifier],:deposit => rmm[:deposit],:administration_fee => rmm[:administration_fee],:rent_frequency => rmm[:rent_frequency],:tenure_type => rmm[:tenure_type],:auction => rmm[:auction],:tenure_unexpired_years => rmm[:tenure_unexpired_years],:price_per_unit_area => rmm[:price_per_unit_area]},						:details => {
				:summary => rmm[:summary],
				:description => rmm[:description],
				:features => rmm[:features],
				:bedrooms => rmm[:bedrooms],
				:bathrooms => rmm[:bathrooms],
				:reception_rooms => rmm[:reception_rooms],
				:parking => rmm[:parking],
				:outside_space => rmm[:outside_space],
				:year_built => rmm[:year_built],
				:internal_area => rmm[:internal_area],
				:internal_area_unit => rmm[:internal_area_unit],
				:land_area => rmm[:land_area],
				:land_area_unit => rmm[:land_area_unit],
				:floors => rmm[:floors],
				:entrance_floor => rmm[:entrance_floor],
				:condition => rmm[:condition],
				:accessibility => rmm[:accessibility],
				:furnished_type => rmm[:furnished_type],
				:pets_allowed => rmm[:pets_allowed],
				:smokers_considered => rmm[:smokers_considered],
				:housing_benefit_considered => rmm[:housing_benefit_considered],
				:sharers_considered => rmm[:sharers_considered],
				:burglar_alarm => rmm[:burglar_alarm],
				:washing_machine => rmm[:washing_machine],
				:dishwasher => rmm[:dishwasher],
				:all_bills_inc => rmm[:all_bills_inc],
				:water_bill_inc => rmm[:water_bill_inc],
				:gas_bill_inc => rmm[:gas_bill_inc],
				:electricity_bill_inc => rmm[:electricity_bill_inc],
				:tv_licence_inc => rmm[:tv_licence_inc],
				:sat_cable_tv_bill_inc => rmm[:sat_cable_tv_bill_inc],
				:internet_bill_inc => rmm[:internet_bill_inc],
				:business_for_sale => rmm[:business_for_sale],
				:comm_use_class => rmm[:comm_use_class],
				:rooms => {:room_name => rmm[:room_name],
					:room_description => rmm[:room_description],
					:room_length => rmm[:room_length],
					:room_width => rmm[:room_width],
					:room_dimension_unit => rmm[:room_dimension_unit],
					:room_photo_urls => rmm[:room_photo_urls]}},
				:media => {
					:media_type => rmm[:media_type], :media_url => rmm[:media_url],
					:caption => rmm[:caption],
					:sort_order => rmm[:sort_order],
					:media_update_date => rmm[:media_update_date]
				},
				:principal => { :principal_email_address => rmm[:principal_email_address], :auto_email_when_live => rmm[:auto_email_when_live], :auto_email_updates => rmm[:auto_email_updates]}
				}}

			# Delete nil values
			data.delete_if { |k, v| v.nil? }

			return data

	end

	# RemoveProperty

	def removeProperty(rmm, removal_reason, transaction_date)

		return {:network => {:network_id => rmm[:network_id]}, :branch => {:branch_id => rmm[:branch_id], :channel => rmm[:channel]}, :property => {{:agent_ref => rmm[:agent_ref], :removal_reason => removal_reason.to_i, :transaction_date => transaction_date.to_s}}}

	end

	# GetBranchProperty

	def getBranchPropertyList(rmm)

		return {:network => {:network_id => rmm[:network_id]}, :branch => {:branch_id => rmm[:branch_id], :channel => rmm[:channel]}}
	end

	###
	## 	Rightmove to PropertyShare
	###

	def convert_rightmove_listing(url)

		document = Nokogiri::HTML(open(url))

		listing = Hash.new

		listing['agent'] = 'belongs to this agent'

		# Title
		listing['title'] = ''

		# Description

		# Price
		price = document.css('#amount').first
		listing['price'] = Integer(price.content.gsub(/\D/,'')) if price
		# frequency = document.css('#rentalfrequency').first
	    # listing['price_frequency'] = frequency.content if frequency

		# Url
		listing['url'] = ''

		# Street
		address_container = document.css('#addresscontainer h2').first
	    listing['address'] = address_container.content.strip if address_container

		# Postcode
		listing['postcode'] = 'what post code'

		# Coordinates
		coord = document.css('#minimapwrapper img').first
		if !coord.nil?
			lat_lng_match = coord['src'].match(/(-?\d+\.\d+),(-?\d+\.\d+)/)
			listing['coordinates'] = [Float(lat_lng_match[1]), Float(lat_lng_match[2])]
	    end 

		# View Count
		listing['view-count'] = 0

		# Active
		listing['active'] = false

	end

end

client = RightmoveClient.new
client.test_send_property
