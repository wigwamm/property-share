require "spec_helper"

describe AvailabilitiesController do
  describe "routing" do

    before do 
      FactoryGirl.create(:agent) do |agent|
        time = Time.now
        @agent = agent
        @property = agent.properties.create(attributes_for(:property))
        @availability = agent.availabilities.create(attributes_for(:availability, start_time: time + 1.days, end_time: time + 2.days ) )
      end
    end

    it "routes to #index" do
      get("/agent/#{@agent.to_param}/availabilities").should route_to("availabilities#index", agent_id: @agent.to_param)
    end

    it "routes to #new" do
      get("/agent/#{@agent.to_param}/availabilities/new").should route_to("availabilities#new", agent_id: @agent.to_param)
    end

    it "routes to #show" do
      get("/agent/#{@agent.to_param}/availabilities/#{@availability.to_param}").should route_to("availabilities#show", :id => @availability.to_param, agent_id: @agent.to_param)
    end

    it "routes to #edit" do
      get("/agent/#{@agent.to_param}/availabilities/#{@availability.to_param}/edit").should route_to("availabilities#edit", :id => @availability.to_param, agent_id: @agent.to_param)
    end

    it "routes to #create" do
      post("/agent/#{@agent.to_param}/availabilities").should route_to("availabilities#create", agent_id: @agent.to_param)
    end

    it "routes to #update" do
      put("/agent/#{@agent.to_param}/availabilities/#{@availability.to_param}").should route_to("availabilities#update", :id => @availability.to_param, agent_id: @agent.to_param)
    end

    it "routes to #destroy" do
      delete("/agent/#{@agent.to_param}/availabilities/#{@availability.to_param}").should route_to("availabilities#destroy", :id => @availability.to_param, agent_id: @agent.to_param)
    end

  end
end
