class AgentController < ApplicationController
  before_action :set_agent, only: [:show]

  def show

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_agent
    @agent = Agent.find(params[:id])
  end

end
