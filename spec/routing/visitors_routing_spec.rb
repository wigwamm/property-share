require "spec_helper"

describe VisitorsController do
  describe "routing" do

    it "routes to #index" do
      get("/visitors").should_not route_to("visitors#index")
    end

    it "routes to #new" do
      get("/visitors/new").should_not route_to("visitors#new")
    end

    it "routes to #show" do
      get("/visitors/1").should_not route_to("visitors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/visitors/1/edit").should_not route_to("visitors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/visitors").should route_to("visitors#create")
    end

    it "routes to #update" do
      put("/visitors/1").should_not route_to("visitors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/visitors/1").should route_to("visitors#destroy", :id => "1")
    end

  end
end
