require 'nokogiri'
require 'open-uri'
require 'mongoid'

require 'openssl'
require 'socket'
require 'net/http'
require 'uri'
require 'json'
require 'pry'
require 'rightmove_config'

require './client'

class RightmovePostError < StandardError
  attr_reader :object
  def initialize(message, object)
    super(message)
    @object = object
  end
end



class RightmoveClient < Client

	attr_accessor :debug, :config
	attr_accessor :client_key, :client_cert, :ca_cert


	def initialize
		super
		loadConfig
	end

	def loadConfig
		self.config = YAML.load(ERB.new(File.read("#{Rails.root}/lib/rightmove_config.yml")).result)[Rails.env].symbolize_keys!
	end

	# Data is a hash
	def post_ssl(data)

		url = 'https://adfapi.rightmove.co.uk:443/v1/property/SendProperty'
		uri = URI.parse(url)

		headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}

		http = Net::HTTP.new(uri.host,uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		http.ca_file = File.join(File.dirname(__FILE__), "./rm.pem")
		response = http.post(uri.path,data.to_json,headers)

		puts response.body		

		binding.pry

		return response.body

	end

	

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

	def post(data, url)

		json = post.to_json

		url = config[:development][:url][:send_property]
		uri = URI.parse(url)

		headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}

		http = Net::HTTP.new(uri.host,uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		http.ca_file = File.join(File.dirname(__FILE__), "./rm.pem")
		response = http.post(uri.path,data.to_json,headers)

		puts response.body

	end


	def test_send_property

		data = {}

		url = rightmove_config[:development][:url][:send_property]
		network_id = rightmove_config[:developement][:network_id]
		branch_id = rightmove_config[:developement][:branch_id]
		channel = 2 #lettings

		# Create groups
		network = create_network_group(network_id)
		branch = create_branch_group(branch_id, channel)


		data.merge!(network)

		# 

		post(data, url)
	end


	###
	##    JSON FORMATTER
	###

	def create_network_group(network_id)
		if network_id.nil? || network_id.is_a?(Integer)
			raise RightmovePostError.new(network_id), "'network_id' is invalid"
		else
			return {"network" => network_id}
		end
	end

	def create_branch_group(branch_id, channel, overseas=nil)
		branch_data = {}

		if branch_id.nil? || !(branch_id.is_a? Integer)
			raise RightmovePostError.new(branch_id), "'branch_id' is invalid"
		elsif channel.nil? || !(channel.is_a? Integer)
			raise RightmovePostError.new(channel), "'channel' is invalid"
		else
			branch_json.merge!("branch" => branch_id)
			branch_json.merge!("channel" => channel)
		end

		if !overseas.nil?
			if !overseas.is_a? Boolean
				raise RightmovePostError.new(overseas), "'overseas' is invalid"
			else
				branch_json.merge!("overseas" => overseas)
			end
		end

		return {"branch" => branch_data}
	end

	# Create property group
	def create_property_group( agent_ref, published, property_type, status, new_home=nil, student_property=nil, house_flat_share=nil, create_date=nil, update_date=nil, date_available=nil, contract_months=nil, minimum_term=nil, let_type=nil)

		property_data = {}

		# Mandatory values
		if agent_ref.nil? || !(agent_ref.is_a? String)
			raise RightmovePostError.new(branch_id), "'branch_id' is invalid"
		elsif published.nil? || !(published.is_a? Boolean)
			raise RightmovePostError.new(published), "'published' is invalid"
		elsif property_type.nil? || !(property_type.is_a? Integer)
			raise RightmovePostError.new(property_type), "'property_type' is invalid"
		elsif status.nil? || !(status.is_a? Integer)
			raise RightmovePostError.new(status), "'channel' is invalid"
		else
			property_data.merge!("agent_ref" => agent_ref)
			property_data.merge!("published" => published)
			property_data.merge!("property_type" => property_type)
			property_data.merge!("status" => status)
		end

		if !new_home.nil?
			if !new_home.is_a? Boolean
				raise RightmovePostError.new(new_home), "'new_home' is invalid"
			else
				property_data.merge!("new_home" => new_home)
			end
		elsif !student_property.nil?
			if !student_property.is_a? Boolean
				raise RightmovePostError.new(student_property), "'student_property' is invalid"
			else
				property_data.merge!("student_property" => student_property)
			end
		elsif !create_date.nil?
			if !create_date.is_a? Boolean
				raise RightmovePostError.new(create_date), "'create_date' is invalid"
			else
				property_data.merge!("create_date" => create_date)
			end
		elsif !update_date.nil?
			if !update_date.is_a? Boolean
				raise RightmovePostError.new(update_date), "'update_date' is invalid"
			else
				property_data.merge!("update_date" => update_date)
			end
		elsif !date_available.nil?
			if !date_available.is_a? Boolean
				raise RightmovePostError.new(date_available), "'date_available' is invalid"
			else
				property_data.merge!("date_available" => date_available)
			end
		elsif !contract_months.nil?
			if !contract_months.is_a? Boolean
				raise RightmovePostError.new(contract_months), "'contract_months' is invalid"
			else
				property_data.merge!("contract_months" => contract_months)
			end
		elsif !minimum_term.nil?
			if !minimum_term.is_a? Boolean
				raise RightmovePostError.new(minimum_term), "'minimum_term' is invalid"
			else
				property_data.merge!("minimum_term" => minimum_term)
			end
		elsif !let_type.nil?
			if !let_type.is_a? Boolean
				raise RightmovePostError.new(let_type), "'let_type' is invalid"
			else
				property_data.merge!("let_type" => let_type)
			end
		elsif !new_home.nil?
			if !new_home.is_a? Boolean
				raise RightmovePostError.new(new_home), "'new_home' is invalid"
			else
				property_data.merge!("new_home" => new_home)
			end
		end

		return {"property" => property_data}

	end

	# address: 231 lavender gardens, battersea, Sw11 8JR
	# lonlat: [51.12321, -1.12312]
	# POV: [Long, Lat, pitch, heading, zoom]
	def create_address_group( house_name_number, address2=nil, address3=nil, address4=nil, town, postcode1, postcode2, display_address, lonlat=nil, pov=nil)

		address_data = {}

		if house_name_number.nil? || !(house_name_number.is_a? String)
			raise RightmovePostError.new(house_name_number), "'house_name_number' is invalid"
		elsif address2.nil? || !(address2.is_a? String)
			raise RightmovePostError.new(address2), "'address2' is invalid"
		elsif address3.nil? || !(address3.is_a? String)
			raise RightmovePostError.new(address3), "'address3' is invalid"
		elsif address4.nil? || !(address4.is_a? String)
			raise RightmovePostError.new(address4), "'address4' is invalid"
		elsif town.nil? || !(town.is_a? String)
			raise RightmovePostError.new(town), "'town' is invalid"
		elsif postcode1.nil? || !(postcode1.is_a? String)
			raise RightmovePostError.new(postcode1), "'postcode1' is invalid"
		elsif postcode2.nil? || !(postcode2.is_a? String)
			raise RightmovePostError.new(postcode2), "'postcode2' is invalid"
		elsif display_address.nil? || !(display_address.is_a? String)
			raise RightmovePostError.new(display_address), "'display_address' is invalid"
		else
			address_data.merge!("house_name_number" => house_name_number)
			address_data.merge!("address2" => address2)
			address_data.merge!("address3" => address3)
			address_data.merge!("address4" => address4)
			address_data.merge!("town" => town)
			address_data.merge!("postcode1" => postcode1)
			address_data.merge!("postcode2" => postcode2)
			address_data.merge!("display_address" => display_address)
		end


		if !lonlat.nil?
			if !lonlat[0].is_a? Double
				raise RightmovePostError.new(lonlat[0]), "'lonlat[0]' is invalid"
			elsif !lonlat[1].is_a? Double
				raise RightmovePostError.new(lonlat[1]), "'lonlat[1]' is invalid"
			else
				address_data.merge!("longitude" => lonlat[0])
				address_data.merge!("latitude" => lonlat[1])
			end
		end

		if !pov.nil?
			if !pov[0].is_a? Double
				raise RightmovePostError.new(pov[0]), "'pov[0] (POV_Longitude)' is invalid"
			elsif !pov[1].is_a? Double
				raise RightmovePostError.new(pov[1]), "'pov[1] (POV_Latitude)' is invalid"
			elsif !pov[1].is_a? Double
				raise RightmovePostError.new(pov[2]), "'pov[2] (POV_Pitch)' is invalid"
			elsif !pov[1].is_a? Double
				raise RightmovePostError.new(pov[3]), "'pov[3] (POV_Heading)' is invalid"
			elsif !pov[1].is_a? Integer
				raise RightmovePostError.new(pov[4]), "'pov[4] (POV_Zoom)' is invalid"
			else
				address_data.merge!("pov_latitude" => pov[0])
				address_data.merge!("pov_longitude" => pov[1])
				address_data.merge!("pov_pitch" => pov[2])
				address_data.merge!("pov_heading" => pov[3])
				address_data.merge!("pov_zoom" => pov[4])
			end
		end

		return {"address" => address_data}

	end

	def create_price_information_group(price, price_qualifier=nil, deposit=nil, 
		amdinistration_fee=nil, rent_frequency=nil, tenure_type=nil, auction=nil, 
		tenure_unexpired_years=nil, price_per_unit_area=nil)
		
		price_data = {}

		if price.nil? || !(price.is_a? Double)
			raise RightmovePostError.new(price), "'price' is invalid"
		else
			price_data.merge!{"price" => price}
		end


		if !price_qualifier.nil?
			if (price_qualifier.is_a? String)
				price_data.merge!("price_qualifier"  => price_qualifier)
			else
				raise RightmovePostError.new(price_qualifier), "'price_qualifier' is invalid"
		elsif deposit.nil? 
			if (deposit.is_a? Integer)
				price_data.merge!("deposit" => deposit)
			else
				raise RightmovePostError.new(deposit), "'deposit' is invalid"
			end
		elsif administration_fee.nil? 
			if (administration_fee.is_a? String)
				price_data.merge!("price_data" => price_data)
			else
				raise RightmovePostError.new(administration_fee), "'administration_fee' is invalid"
			end
		elsif rent_frequency.nil? 
			if (rent_frequency.is_a? Integer)
				price_data.merge!("rent_frequency" => rent_frequency)
			else
				raise RightmovePostError.new(rent_frequency), "'rent_frequency' is invalid"
			end
		elsif tenure_type.nil? 
			if (tenure_type.is_a? Integer)
				price_data.merge!("tenure_type" => tenure_type)
			else
				raise RightmovePostError.new(tenure_type), "'tenure_type' is invalid"
			end
		elsif auction.nil? 
			if (auction.is_a? Boolean)
				price_data.merge!("auction" => auction)
			else
				raise RightmovePostError.new(auction), "'auction' is invalid"	
			end
		elsif tenure_unexpired_years.nil? 
			if (tenure_unexpired_years.is_a? Integer)
				price_data.merge!("tenure_unexpired_years" => tenure_unexpired_years)
			else
				raise RightmovePostError.new(tenure_unexpired_years), "'tenure_unexpired_years' is invalid"
			end
		elsif price_per_unit_area.nil? 
			if (price_per_unit_area.is_a? Double)
				price_data.merge!("price_per_unit_area" => price_per_unit_area)
			else
				raise RightmovePostError.new(price_per_unit_area), "'price_per_unit_area' is invalid"
			end
		end

		return price_data

	end

	def create_details_group(summary, description, features=nil, bedrooms, 
		bathrooms=nil, reception_rooms=nil, parking=nil, outside_space=nil, 
		year_built=nil, internal_area_unit=nil, land_area=nil, land_area=nil)

		details_data = {}

		if summary.nil? || !(summary.is_a? String)
			raise RightmovePostError.new(summary), "'summary' is invalid"
		elsif description.nil? || !(description.is_a? String)
			raise RightmovePostError.new(description), "'description' is invalid"
		elsif bedrooms.nil? || !(bedrooms.is_a? Integer)
			raise RightmovePostError.new(features), "'bedrooms' is invalid"
		else
			details_data.merge!("summary" => summary)
			details_data.merge!("description" => description)
			details_data.merge!("bedrooms" => bedrooms)
		end

		if features.nil?
			if (features.is_a? Array)
				details_data.merge!(features)
			else
				raise RightmovePostError.new(features), "'features' is invalid"
			end
		elsif bathrooms.nil? 
			if (bathrooms.is_a? Integer)
				details_data.merge!(bedrooms)
			else
				raise RightmovePostError.new(bathrooms), "'bathrooms' is invalid"
			end
		elsif reception_rooms.nil? 
			if (reception_rooms.is_a? Integer)
				details_data.merge!(reception_rooms)
			else
				raise RightmovePostError.new(reception_rooms), "'reception_rooms' is invalid"
			end
		elsif parking.nil? 
			if (parking.is_a? Array)
				details_data.merge!(parking)
			else
				raise RightmovePostError.new(parking), "'parking' is invalid"
			end
		elsif outside_space.nil? 
			if (outside_space.is_a? Array)
				details_data.merge!(outside_space)
			else
				raise RightmovePostError.new(outside_space), "'outside_space' is invalid"
			end
		elsif year_built.nil? 
			if (year_built.is_a? Float)
				details_data.merge!(year_built)
			else
				raise RightmovePostError.new(year_built), "'year_built' is invalid"
			end
		elsif internal_area_unit.nil? 
			if (internal_area_unit.is_a? Integer)
				details_data.merge!(internal_area_unit)
			else
				raise RightmovePostError.new(internal_area_unit), "'internal_area_unit' is invalid"
			end
		elsif land_area.nil? 
			if(land_area.is_a? Float)
				details_data.merge!(land_area)
			else
				raise RightmovePostError.new(land_area), "'land_area' is invalid"
			end
		elsif land_area_unit.nil? 
			if (land_area_unit.is_a? Integer)
				details_data.merge!(land_area_unit)
			else
				raise RightmovePostError.new(land_area_unit), "'land_area_unit' is invalid"
			end
		elsif floors.nil? 
			if (floors.is_a? Integer)
				details_data.merge!(floors)
			else
				raise RightmovePostError.new(floors), "'floors' is invalid"
			end
		elsif entrance_floor.nil? 
			if (entrance_floor.is_a? Integer)
				details_data.merge!(entrance_floor)
			else
				raise RightmovePostError.new(entrance_floor), "'entrance_floor' is invalid"
			end
		elsif condition.nil? 
			if (condition.is_a? Integer)
				details_data.merge!(condition)
			else
				raise RightmovePostError.new(condition), "'condition' is invalid"
			end
		elsif accessibility.nil? 
			if (accessibility.is_a? Array)
				details_data.merge!(accessibility)
			else
				raise RightmovePostError.new(accessibility), "'accessibility' is invalid"
			end
		elsif heating.nil? 
			if (heating.is_a? Array)
				details_data.merge!(heating)
			else
				raise RightmovePostError.new(heating), "'heating' is invalid"
			end
		elsif furnished_type.nil? 
			if (furnished_type.is_a? Boolean)
				details_data.merge!(furnished_type)
			else
				raise RightmovePostError.new(furnished_type), "'furnished_type' is invalid"
			end
		elsif pets_allowed.nil? 
			if (pets_allowed.is_a? Boolean)
				details_data.merge!(pets_allowed)
			else
				raise RightmovePostError.new(pets_allowed), "'pets_allowed' is invalid"
			end
		elsif smokers_considered.nil? 
			if (smokers_considered.is_a? Boolean)
				details_data.merge!(smokers_considered)
			else
				raise RightmovePostError.new(smokers_considered), "'smokers_considered' is invalid"
			end
		elsif housing_benefit_considered.nil? 
			if (housing_benefit_considered.is_a? Boolean)
				details_data.merge!(housing_benefit_considered)
			else
				raise RightmovePostError.new(housing_benefit_considered), "'housing_benefit_considered' is invalid"
			end
		elsif sharers_considered.nil? 
			if (sharers_considered.is_a? Boolean)
				details_data.merge!(sharers_considered)
			else
				raise RightmovePostError.new(sharers_considered), "'sharers_considered' is invalid"
			end
		elsif smokers_considered.nil? 
			if (smokers_considered.is_a? Boolean)
				details_data.merge!(smokers_considered)
			else
				raise RightmovePostError.new(smokers_considered), "'smokers_considered' is invalid"
			end
		elsif burglar_alarm.nil? 
			if (burglar_alarm.is_a? Boolean)
				details_data.merge!(burglar_alarm)
			else
				raise RightmovePostError.new(burglar_alarm), "'burglar_alarm' is invalid"
			end
		elsif washing_machine.nil? 
			if (washing_machine.is_a? Boolean)
				details_data.merge!(washing_machine)
			else
				raise RightmovePostError.new(washing_machine), "'washing_machine' is invalid"
			end
		elsif dishwasher.nil? 
			if (dishwasher.is_a? Boolean)
				details_data.merge!(dishwasher)
			else
				raise RightmovePostError.new(dishwasher), "'dishwasher' is invalid"
			end
		elsif all_bills_inc.nil? 
			if (all_bills_inc.is_a? Boolean)
				details_data.merge!(all_bills_inc)
			else
				raise RightmovePostError.new(all_bills_inc), "'all_bills_inc' is invalid"
			end
		elsif water_bill_inc.nil? 
			if (water_bill_inc.is_a? Boolean)
				details_data.merge!(water_bill_inc)
			else
				raise RightmovePostError.new(water_bill_inc), "'water_bill_inc' is invalid"
			end
		elsif gas_bill_inc.nil? 
			if (gas_bill_inc.is_a? Boolean)
				details_data.merge!(gas_bill_inc)
			else
				raise RightmovePostError.new(gas_bill_inc), "'gas_bill_inc' is invalid"
			end
		elsif electricity_bill_inc.nil? 
			if (electricity_bill_inc.is_a? Boolean)
				details_data.merge!(electricity_bill_inc)
			else
				raise RightmovePostError.new(electricity_bill_inc), "'electricity_bill_inc' is invalid"
			end
		elsif tv_licence_inc.nil? 
			if (tv_licence_inc.is_a? Boolean)
				details_data.merge!(tv_licence_inc)
			else
				raise RightmovePostError.new(tv_licence_inc), "'tv_licence_inc' is invalid"
			end
		elsif sat_cable_tv_bill_inc.nil? 
			if (sat_cable_tv_bill_inc.is_a? Boolean)
				details_data.merge!(sat_cable_tv_bill_inc)
			else
				raise RightmovePostError.new(sat_cable_tv_bill_inc), "'sat_cable_tv_bill_inc' is invalid"
			end
		elsif internet_bill_inc.nil? 
			if (internet_bill_inc.is_a? Boolean)
				details_data.merge!(internet_bill_inc)
			else
				raise RightmovePostError.new(internet_bill_inc), "'internet_bill_inc' is invalid"
			end
		elsif business_for_sale.nil? 
			if (business_for_sale.is_a? Boolean)
				details_data.merge!(business_for_sale)
			else
				raise RightmovePostError.new(business_for_sale), "'business_for_sale' is invalid"
			end
		elsif comm_use_class.nil? 
			if (comm_use_class.is_a? Array)
				details_data.merge!(comm_use_class)
			else
				raise RightmovePostError.new(comm_use_class), "'comm_use_class' is invalid"
			end
		end

		return {"details" => details_data}
	end

	def create_rooms_group(room_name, room_description, room_length, room_width, room_dimension_unit, room_photo_urls)
		rooms_data = {}

		if room_name.nil? || !(room_name.is_a? String)
			raise RightmovePostError.new(room_name), "'room_name' is invalid"
		else
			rooms_data.merge!("room_name" => room_name)
		end

		if !room_description.nil?
			if !room_description.is_a? String
				raise RightmovePostError.new(room_description), "'room_description' is invalid"
			else
				rooms_data.merge!("room_description" => room_description)
			end
		elsif !room_length.nil?
			if !room_length.is_a? Integer
				raise RightmovePostError.new(room_length), "'room_length' is invalid"
			else
				rooms_data.merge!("room_length" => room_length)
			end
		elsif !room_width.nil?
			if !room_width.is_a? Integer
				raise RightmovePostError.new(room_width), "'room_width' is invalid"
			else
				rooms_data.merge!("room_width" => room_width)
			end
		elsif !room_dimension_unit.nil?
			if !room_dimension_unit.is_a? Integer
				raise RightmovePostError.new(room_dimension_unit), "'room_dimension_unit' is invalid"
			else
				rooms_data.merge!("room_dimension_unit" => room_dimension_unit)
			end
		elsif !room_photo_urls.nil?
			if !room_photo_urls.is_a? Integer
				raise RightmovePostError.new(room_photo_urls), "'room_photo_urls' is invalid"
			else
				rooms_data.merge!("room_photo_urls" => room_photo_urls)
			end
		end

		return {"rooms" => rooms_data}

	end

	def create_media_group(media_type, media_url, caption=nil, sort_order=nil, media_update_date=nil)
		media_data = {}

		if media_type.nil? || !(media_type.is_a? Integer)
			raise RightmovePostError.new(media_type), "'media_type' is invalid"
		elsif media_url.nil? || !(media_url.is_a? String)
			raise RightmovePostError.new(media_url), "'media_url' is invalid"
		else
			media_data.merge!("room_name" => room_name)
			media_data.merge!("media_url" => media_url)
		end

		if !caption.nil?
			if !caption.is_a? String
				raise RightmovePostError.new(caption), "'caption' is invalid"
			else
				media_data.merge!("caption" => caption)
			end
		elsif !sort_order.nil?
			if !sort_order.is_a? Integer
				raise RightmovePostError.new(sort_order), "'sort_order' is invalid"
			else
				media_data.merge!("sort_order" => sort_order)
			end
		elsif !media_update_date.nil?
			if !media_update_date.is_a? Integer
				raise RightmovePostError.new(media_update_date), "'media_update_date' is invalid"
			else
				media_data.merge!("media_update_date" => media_update_date)
			end
		end

		return {"media" => media_data}

	end

end

client = RightmoveClient.new
client.test
