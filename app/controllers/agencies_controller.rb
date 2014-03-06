class AgenciesController < ApplicationController
  before_action :set_agency, only: [:destroy]

  # POST /agencies
  # POST /agencies.json
  def new
    @agency = Agency.new
  end

  def create
    @agency = Agency.new(agency_params)
    respond_to do |format|
      if @agency.save
        luke = Agent.where(mobile: "+447503267332")
        @agreement = Agreement.create(gentleman_id: luke.id, courter_id: @agency.id)
        introduction_args = { agreement_id: @agreement.id.to_s, action: "introduction", args: {agency: {name: @agency.name, contact: @agency.contact , phone: @agency.phone}}}
        Resque.enqueue(BackroomAgreement, "handshake", introduction_args)
        format.html { redirect_to thanks_path }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.json
  def destroy
    @agency.destroy
    respond_to do |format|
      @agencies = agency.where(agent_id: current_agent.id).where( :available_at => { :$gte => DateTime.now.beginning_of_day }).asc(:available_at)
      @grouped_agencies = @agencies.all.group_by{|v| v.available_at.beginning_of_day }.values if @agencies.any?
      format.html { redirect_to agencies_url }
      format.js
      # format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency
      @agency = current_agent.agencies.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agency_params
      params.require(:agency).permit(:name, :contact, :email, :phone, :agency_size, :notes)
    end
end
