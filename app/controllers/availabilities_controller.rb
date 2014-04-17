class AvailabilitiesController < ApplicationController
  before_action :authenticate_agent!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_agent, only: [:index, :show]
  before_action :set_availability, only: [:edit, :update, :destroy]

  # GET /availabilities
  # GET /availabilities.json
  def index
    # Just show availabilites for the current agent
    @availabilities = @agent.availabilities.all
  end

  # GET /availabilities/1
  # GET /availabilities/1.json
  def show
    @availability = @agent.availabilities.find(params[:id])
  end

  # GET /availabilities/new
  def new
    @availability = current_agent.availabilities.new
  end

  # GET /availabilities/1/edit
  def edit
  end

  # POST /availabilities
  # POST /availabilities.json
  def create
    @availability = current_agent.availabilities.new(availability_params)

    respond_to do |format|
      if @availability.save
        format.html { redirect_to @availability, notice: 'Availability was successfully created.' }
        format.json { render action: 'show', status: :created, location: @availability }
      else
        format.html { render action: 'new' }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /availabilities/1
  # PATCH/PUT /availabilities/1.json
  def update
    respond_to do |format|
      if @availability.update(availability_params)
        format.html { redirect_to @availability, notice: 'Availability was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.json
  def destroy
    @availability.destroy
    respond_to do |format|
      format.html { redirect_to availabilities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:agent_id])
    end

    def set_availability
      @agent = current_agent
      @availability = @agent.availabilities.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def availability_params
      params.require(:availability).permit(:agent_id, :start_time, :end_time, :booked, :created_by, :updated_by)
    end
end
