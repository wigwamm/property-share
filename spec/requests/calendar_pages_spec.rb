require 'spec_helper'

describe "Calendar Pages" do

  subject { page }

  before do 
    FactoryGirl.create(:agent) do |agent|
      @agent = agent
      @property = agent.properties.create(attributes_for(:property))
    end
  end

  describe "when signed in" do

    before do
      visit new_agent_session_path
      valid_signin(@agent)
    end

    describe "show" do
        
      describe "property calendar" do 

        before { visit property_calendar_path(@property) }

        describe "page" do
          it { should have_selector "h1", text: "#{@property.class} Calendar" }
          
          it "have a calendar" do   
            Capybara.match = :first
            within("ol.calendar") do
              within("li.week") do
                within("ol.days") do
                  should have_selector "ol.weekday", text: "Monday"
                  should have_selector "ol.weekday", text: "Tuesday"
                  should have_selector "ol.weekday", text: "Wednesday"
                  should have_selector "ol.weekday", text: "Thursday"
                  should have_selector "ol.weekday", text: "Friday"
                  should have_selector "ol.weekend", text: "Saturday"
                  should have_selector "ol.weekend", text: "Sunday"
                end
              end
            end
          end

        end

      end

      describe "agent calendar" do 
        
        before { visit agent_calendar_path(@agent) }

        describe "page" do
          it { should have_selector "h1", text: "#{@agent.class} Calendar" }
          it "should have a calendar" do   
            Capybara.match = :first
            within("ol.calendar") do
              within("li.week") do
                within("ol.days") do
                  should have_selector "ol.weekday", text: "Monday"
                  should have_selector "ol.weekday", text: "Tuesday"
                  should have_selector "ol.weekday", text: "Wednesday"
                  should have_selector "ol.weekday", text: "Thursday"
                  should have_selector "ol.weekday", text: "Friday"
                  should have_selector "ol.weekend", text: "Saturday"
                  should have_selector "ol.weekend", text: "Sunday"
                end
              end
            end
          end

        end

      end


    end

    describe "new availability" do

      before { visit new_agent_availability_path(@agent) }

      describe "page" do
        it { should have_selector "h1", text: "Add Availability" }
        it { should have_selector "form" }        
      end

      describe "with invalid information" do
        before { fill_in "availability_start_time", with: "%H:%M" }
        it "should NOT create a availability" do
          expect{ click_button "Add" }.not_to change(Availability, :count)
        end

        describe "after press" do
          before { click_button "Add" }
          it { should have_content "error" }
        end
      end

      describe "with valid information" do

        before do
          @valid_information = FactoryGirl.attributes_for(:availability)
          select "Tomorrow",                    from: 'availability_start_date'
          fill_in "availability_start_time",    with: @valid_information[:start_time].strftime("%H:%M")
          select "Tomorrow",                    from: 'availability_start_date'
          fill_in "availability_end_time",      with: @valid_information[:end_time].strftime("%H:%M")
        end

        it "should create a availability" do
          expect{ click_button "Add" }.to change(Availability, :count).by(1)
        end

      end

    end
  end




  
end