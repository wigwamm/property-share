require "spec_helper"

describe ImagesController do
  describe "routing" do

    before do 
      FactoryGirl.create(:agent) do |agent|
        @property = agent.properties.create(attributes_for(:property))
      end
    end

    it "routes to #create" do
      post("#{@property.to_param}/images").should route_to("images#create", :property_id => @property.to_param)
    end

    # Routes don't work as no image in TEST DB

    it "routes to #destroy" do
      delete("#{@property.to_param}/images/1").should route_to("images#destroy", :id => "1", :property_id => @property.to_param)
    end

  end
end
