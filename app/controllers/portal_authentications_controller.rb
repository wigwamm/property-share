class PortalAuthenticationsController < ApplicationController
  before_action :set_portal_authentication, only: [:show, :edit, :update, :destroy]

  # GET /portal_authentications
  # GET /portal_authentications.json
  def index
    @portal_authentications = PortalAuthentication.all
  end

  # GET /portal_authentications/1
  # GET /portal_authentications/1.json
  def show
  end

  # GET /portal_authentications/new
  def new
    @portal_authentication = PortalAuthentication.new
  end

  # GET /portal_authentications/1/edit
  def edit
  end

  # POST /portal_authentications
  # POST /portal_authentications.json
  def create
    binding.pry
    @portal_authentication = PortalAuthentication.new(portal_authentication_params)

    respond_to do |format|
      if @portal_authentication.save
        format.html { redirect_to @portal_authentication, notice: 'Portal authentication was successfully created.' }
        format.json { render action: 'show', status: :created, location: @portal_authentication }
      else
        format.html { render action: 'new' }
        format.json { render json: @portal_authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portal_authentications/1
  # PATCH/PUT /portal_authentications/1.json
  def update
    respond_to do |format|
      if @portal_authentication.update(portal_authentication_params)
        format.html { redirect_to @portal_authentication, notice: 'Portal authentication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @portal_authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portal_authentications/1
  # DELETE /portal_authentications/1.json
  def destroy
    @portal_authentication.destroy
    respond_to do |format|
      format.html { redirect_to portal_authentications_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portal_authentication
      @portal_authentication = PortalAuthentication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def portal_authentication_params
      params.require(:portal_authentication).permit(:ssl, :username, :password, :pem, :pkcs12)
    end
end
