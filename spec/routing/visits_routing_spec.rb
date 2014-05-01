require "spec_helper"

describe VisitsController do
  describe "routing" do

    before do 
      FactoryGirl.create(:agent) do |agent|
        time = Time.now
        @property = agent.properties.create(attributes_for(:property))
        availability = agent.availabilities.create(attributes_for(:availability, start_time: time + 1.days, end_time: time + 2.days ) )
        @visit = @property.visits.create(attributes_for(:visit, start_time: availability.start_time + 10.minutes, end_time: availability.end_time + 40.minutes) )
      end
    end

    it "routes to #index" do
      get("#{@property.to_param}/visits").should route_to("visits#index", :property_id => @property.to_param)
    end

    it "routes to #new" do
      get("#{@property.to_param}/visits/new").should route_to("visits#new", :property_id => @property.to_param)
    end

    it "routes to #show" do
      get("#{@property.to_param}/visits/#{@visit.to_param}").should route_to("visits#show", :id => @visit.to_param, :property_id => @property.to_param )
    end

    it "routes to #edit" do
      get("#{@property.to_param}/visits/#{@visit.to_param}/edit").should route_to("visits#edit", :id => @visit.to_param, :property_id => @property.to_param)
    end

    it "routes to #create" do
      post("#{@property.to_param}/visits").should route_to("visits#create", :property_id => @property.to_param)
    end

    it "routes to #update" do
      put("#{@property.to_param}/visits/#{@visit.to_param}").should route_to("visits#update", :id => @visit.to_param, :property_id => @property.to_param)
    end

    it "routes to #destroy" do
      delete("#{@property.to_param}/visits/#{@visit.to_param}").should route_to("visits#destroy", :id => @visit.to_param, :property_id => @property.to_param)
    end

  end
end
