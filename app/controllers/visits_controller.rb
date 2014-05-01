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
    @property = Property.find(params[:property_id])
    agent = @property.agent
    availability = agent.availabilities.where(id: visit_params[:availability_id]).where(booked: false).first
    if availability && visitor_params[:visitor_attributes][:mobile]
      visitor = find_or_initialize_visitor_from_mobile(visitor_params[:visitor_attributes][:mobile])
      unless visitor.persisted?
        visitor.conversion_property = @property._id
        # Add cookie tracking here
        visitor.save
      end
      @visit = @property.visits.new( start_time: availability.start_time, 
                                    visitor_id: visitor._id, 
                                    agent_id: agent._id, 
                                    availability_id: availability._id)
      if @visit.save
        @agreement = Agreement.create(gentleman_id: agent.id.to_s, courter_id: visitor.id.to_s)
        setup_args = { agreement_id: @agreement.id.to_s, action: "setup_visit", args: {visit_id: @visit.id.to_s}}
        reminder_args = { agreement_id: @agreement.id.to_s, action: "reminder", args: {visit_id: @visit.id.to_s}}
        remind_time = @visit.start_time - 1.hour
        respond_to do |format|
          if Resque.enqueue(BackroomAgreement, "handshake", setup_args)
            Resque.enqueue_at(remind_time, BackroomAgreement, "handshake", reminder_args) unless @visit.start_time < DateTime.now + 1.hour
            puts "visit created"
            availability.book!
            format.html { redirect_to @property, notice: 'Visit was successfully created' }
            format.js
          else
            format.html { redirect_to @property, :notice => "Sorry there was an error please try again." }
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

  def find_or_initialize_visitor_from_mobile(mobile)
    return Visitor.find_or_initialize_by(mobile: format_mobile(mobile))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_visit
    @visit = Visit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visit_params
    params.require(:visit).permit(:availability_id)
  end
  def visitor_params
    params.require(:visit).permit(visitor_attributes: [:mobile])
  end

end
