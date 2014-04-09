class RightmovePropertiesController < ApplicationController
  before_action :set_rightmove_property, only: [:show, :edit, :update, :destroy]

  # GET /rightmove_properties
  # GET /rightmove_properties.json
  def index
    @rightmove_properties = RightmoveProperty.all
  end

  # GET /rightmove_properties/1
  # GET /rightmove_properties/1.json
  def show
  end

  # GET /rightmove_properties/new
  def new
  end

  # GET /rightmove_properties/1/edit
  def edit
  end

  # POST /rightmove_properties
  # POST /rightmove_properties.json
  def create(property_id)
    property = Property.where(_id: property_id).first
    # translate_property(property)
  end

  def translate_property(property, publish=true)

    agency = property.agent.agency

    @rightmove_property.network_id = "ENV{NETWORK_ID}"
    @rightmove_property.branch_id = @rightmove_property.portal.branch_id
    @rightmove_property.channel =  property.saleorlet #  Sale or Letting - 1 or 2
    
    # Property Group
    @rightmove_property.agent_ref = @portal.branch_id.to_s+property.ref
    @rightmove_property.published = publish
    @rightmove_property.created_at = Time.now.strftime("dd-MM-yyyy HH:mm:ss")
    @rightmove_property.date_available = property.date_available

    # Address Group
    @rightmove_property.house_name_number = property.street.split(" ").first
    @rightmove_property.address2 = property.street.gsub(@rightmove_property.house_name_number+" ","")
    @rightmove_property.postcode1 = property.postcode.scan(/[A-Z]{1,2}[0-9]{1,2}/)
    @rightmove_property.postcode2 = property.postcode.gsub(@rightmove_property.postcode1,"")
    @rightmove_property.display_address = property.address()

    # Price Group
    @rightmove_property.price = property.price.gsub(/[^\d]/, '')
    @rightmove_property.administration_fees = agency.administration_fees
    #  If property is for sale
    if @rightmove_property.channel == 1
      @rightmove_property.tenure_type = property.tenure_type
      @rightmove_property.tenure_unexpired_years = property.tenure_unexpired_years
    end

    # Details
    @rightmove_property.summary = property.description.truncate(17, separator: ' ')
    @rightmove_property.description = property.description
    @rightmove_property.bedrooms = property.bedrooms

    # Media
    for img in @property.images
      @rightmove_property.rightmove_mediums.build({media_type: 1, media_url: img.photo(:large)})
    end

  end

  # PATCH/PUT /rightmove_properties/1
  # PATCH/PUT /rightmove_properties/1.json
  def update
    respond_to do |format|
      if @rightmove_property.update(rightmove_property_params)
        format.html { redirect_to @rightmove_property, notice: 'Rightmove property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rightmove_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rightmove_properties/1
  # DELETE /rightmove_properties/1.json
  def destroy
    @rightmove_property.destroy
    respond_to do |format|
      format.html { redirect_to rightmove_properties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rightmove_property
      @rightmove_property = RightmoveProperty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rightmove_property_params
      params[:rightmove_property]
    end
end
