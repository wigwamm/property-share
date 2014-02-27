class VisitsController < ApplicationController

  def create
    property = Property.find(visit_params[:property_id])
    agent = property.agent
    availability = agent.availabilities.where(id: visit_params[:availability_id]).where(booked: false).first
    if availability
      user = find_or_create_user_from_mobile(user_params[:mobile])
      @visit = user.visits.new(visit_params)
      @visit.scheduled_at = availability.available_at
      respond_to do |format|
        if @visit.save
          @agreement = Agreement.create(gentleman_id: agent.id.to_s, courter_id: user.id.to_s)
          setup_args = { agreement_id: @agreement.id.to_s, action: "setup_visit", args: {visit_id: @visit.id.to_s}}
          reminder_args = { agreement_id: @agreement.id.to_s, action: "reminder", args: {visit_id: @visit.id.to_s}}
          if Resque.enqueue(BackroomAgreement, "handshake", setup_args)
            remind_time = @visit.scheduled_at - 1.hour
            Resque.enqueue_at( remind_time, BackroomAgreement, "handshake", reminder_args)
            availability.book!
            format.html { redirect_to @visit, notice: 'Visit was successfully created' }
            format.json {  }
          else
            redirect_to @property, :notice => "Sorry there was an error please try again."
            format.html { render action: 'new' }
            format.json { render json: @visit.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  def reminder
    @next_hour = Visit.where( :scheduled_at => { :$gte => DateTime.now, 
                                               :$lte => DateTime.now + 1.hour } 
                                    ).where(:reminder_sent => false ).asc(:scheduled_at)
    @next_hour.each do |visit|
      agent = visit.agent
      property = visit.property
      user = visit.user
      @agreement = Agreement.where(gentleman_id: agent.id).where(courter_id: user.id).where(:actions => "pending").where(complete: false).first
      @agreement.handshake("reminder", {visit_id: visit.id})
    end
  end

  # # PATCH/PUT /visits/1
  # # PATCH/PUT /visits/1.json
  # def update
  #   respond_to do |format|
  #     if @visit.update(visit_params)
  #       format.html { redirect_to @visit, notice: 'Visit was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @visit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /visits/1
  # # DELETE /visits/1.json
  # def destroy
  #   @visit.destroy
  #   respond_to do |format|
  #     format.html { redirect_to visits_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_visit
    #   @visit = Visit.find(params[:id])
    # end

    def find_or_create_user_from_mobile(mobile)
      mob = format_mobile(mobile)
      user = User.create(mobile: mob) unless user = User.where(mobile: mob).first
      return user
    end

    def format_mobile(number)
      number.gsub!(/[^\d\+]/,'')
      number = "+44" + number[1..-1] if number[0..1] == "07"
      number = "+" + number[0..-1] if number[0..1] == "44"
      number = "+44" + number[4..-1] if number[0..3] == "0044"
      return number
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_params
      params.require(:visit).permit(:availability_id, :user_id, :property_id, :agent_id, :scheduled_at)
    end

    def user_params
      params.require(:user).permit(:mobile)
    end
end



