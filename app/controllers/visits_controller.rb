class VisitsController < ApplicationController
  before_action :set_visit, only: [:show, :edit, :update, :destroy]

  # # GET /visits
  # # GET /visits.json
  # def index
  #   @visits = Visit.all
  # end

  # GET /visits/1
  # GET /visits/1.json
  def show
  end

  # # GET /visits/new
  # def new
  #   @visit = Visit.new
  # end

  # # GET /visits/1/edit
  # def edit
  # end

  # # POST /visits
  # # POST /visits.json
  # def create
  #   @visit = Visit.new(visit_params)

  #   respond_to do |format|
  #     if @visit.save
  #       format.html { redirect_to @visit, notice: 'Visit was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @visit }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @visit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def create
    property = Property.find(visit_params[:property_id])
    agent = property.agent
    availability = agent.availabilities.where(id: visit_params[:availability_id]).where(booked: false).first
    if availability
      user = find_or_create_visitor_from_mobile(user_params[:mobile])
      @visit = user.visits.new(visit_params)
      @visit.scheduled_at = availability.available_at
      if @visit.save
        @agreement = Agreement.create(gentleman_id: agent.id.to_s, courter_id: user.id.to_s)
        setup_args = { agreement_id: @agreement.id.to_s, action: "setup_visit", args: {visit_id: @visit.id.to_s}}
        reminder_args = { agreement_id: @agreement.id.to_s, action: "reminder", args: {visit_id: @visit.id.to_s}}
        remind_time = @visit.scheduled_at - 1.hour
        respond_to do |format|
          if Resque.enqueue(BackroomAgreement, "handshake", setup_args)
            Resque.enqueue_at(remind_time, BackroomAgreement, "handshake", reminder_args) unless @visit.scheduled_at < DateTime.now + 1.hour
            puts "visit created"
            availability.book!
            format.html { redirect_to @visit, notice: 'Visit was successfully created' }
            format.js
          else
            redirect_to @property, :notice => "Sorry there was an error please try again."
            format.html { render action: 'new' }
            format.json { render json: @visit.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
  def update
    respond_to do |format|
      if @visit.update_attributes(visit_params)
        format.html { redirect_to @visit, notice: 'Visit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.json
  def destroy
    @visit.destroy
    respond_to do |format|
      format.html { redirect_to visits_url }
      format.json { head :no_content }
    end
  end

  private

  def find_or_create_visitor_from_mobile(mobile)
    return Visitor.find_or_create_by(mobile: mobile)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_visit
    @visit = Visit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visit_params
    params.require(:visit).permit(:start_time, :end_time, :confirmed)
  end

  def user_params
    params.require(:visitor).permit(:mobile)
  end

end
