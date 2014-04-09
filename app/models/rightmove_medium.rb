class RightmoveMedium
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :rightmove_property

  field :media_type, 		     	type: Integer # 1 Image, 2 Floorplan, 3 Brochure, 4 Virtual Tour, 5 Audio Tour, 6 EPC, 7 EPC Graph
  field :media_url, 			    type: String
  field :caption, 				    type: String
  field :sort_order, 			    type: Integer 
  field :media_update_date, 	type: String # Format: dd-MM-yyyy HH:mm:ss

  before_validation :check_url, :check_media_type

  validates_presence_of :media_type, :media_url

  def valid_url?
    begin
      uri = URI.parse(media_url)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end

  def check_media_type?
    if ![1,2,3,4,5,6,7].include?(media_type)
      raise "'"+media_type.to_s+"' is not a valid choice - 1 Image, 2 Floorplan, 3 Brochure, 4 Virtual Tour, 5 Audio Tour, 6 EPC, 7 EPC Graph"
    end
  end

end
