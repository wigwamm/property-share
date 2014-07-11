class Property
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :branch_id

  belongs_to :agent
  has_many :visits
  
  has_many :media, dependent: :destroy
  embeds_one :address
  embeds_one :price_information
  has_one :detail, dependent: :destroy
  has_one :principal, dependent: :destroy
  has_many :bookings

  accepts_nested_attributes_for :media, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :price_information, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :detail, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :principal, reject_if: :all_blank, allow_destroy: true


  field :view_count,              type: Integer
  field :active,                  type: Boolean, default: true

  field :published,               type: Boolean, default: true
  field :property_type,           type: Integer, default: 0
  field :status,                  type: Integer, default: 1
  field :trans_type,              type: Integer, default: 1
  field :let_date_available,      type: DateTime
  field :let_type,                type: Integer, default: 0
  field :new_home,                type: Boolean, default: false
  field :rightmove_id,            type: String

  # field :student_property,        type: Boolean, default: false
  # field :contract_months,         type: Integer
  # field :minimum_term,            type: Integer

  TYPE = YAML.load(File.read(Rails.root.join('config', 'property_type.yml')))
  STATUS = ['Available', 'SSTC (Sales only)', 'SSTCM (Scottish Sales only)', 'Under Offer (Sales only)', 'Reserved (Sales only)', 'Let Agreed (Lettings only)']
  TRANS_TYPE = %w(Sales Rental)
  LET_TYPE = ['Not Specified', 'Long Term', 'Short Term', 'Student', 'Commercial']
  ASSOCIATIONS = %w(address price_information details media principal)

  after_create :sort_media

  validates_presence_of :property_type, :status, :published

  def title; detail.try(:summary); end
  def to_param; id.to_s; end
  def images; media.images; end
  def agent_ref; "#{branch_id}_#{to_param}"; end
  def prop_sub_id; property_type; end
  def status_id; status; end
  def trans_type_id; trans_type; end
  def published_flag; published? ? 1 : 0; end
  def new_home_flag; new_home? ? 'Y' : 'N'; end
  def create_date; created_at.strftime("%d-%m-%Y %H:%M:%S"); end
  def update_date; updated_at.strftime("%d-%m-%Y %H:%M:%S"); end
  def address_1; address.house_name_number; end
  def address_2; address.address_2; end
  def address_3; address.address_3; end
  def address_4; address.address_4; end
  def town; address.town; end
  def postcode1; address.postcode_1; end
  def postcode2; address.postcode_2; end
  def display_address; address.display_address; end
  def price; price_information.price.to_i; end
  def price_qualifier; price_information.price_qualifier; end
  def tenure_type_id; price_information.tenure_type; end
  def let_rent_frequency; price_information.rent_frequency; end
  def let_bond; price_information.deposit.to_i; end
  def summary; detail.summary; end
  def description; detail.description; end
  def let_furn_id; detail.furnished_type; end
  def bedrooms; detail.bedrooms; end
  def feature1; detail.features[0].to_s rescue nil; end
  def feature2; detail.features[1].to_s rescue nil; end
  def feature3; detail.features[2].to_s rescue nil; end


  def rightmove_url
    "http://www.adftest.rightmove.com/property-to-rent/property-#{rightmove_id}.html"
  end

  def self.list
    Rightmove.instance.list
  end

    def upload
      response = Rightmove.instance.add to_param
      puts response.inspect 
      if response['success']
        update_attributes rightmove_id: response['property']['rightmove_id']
      else
        errors.add :base, response['message']
      end
    end

  def remove
    response = Rightmove.instance.remove to_param
    
    if response['success']
      destroy
    else
      errors.add :base, response['message']
    end
  end
  

  protected

  def sort_media
    self.media.each_with_index do |medium, i| 
      medium.update_attribute(:sort_order, i+1)
    end
  end
end
