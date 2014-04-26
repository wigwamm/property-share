require 'spec_helper'

describe "Agent Pages" do

  subject { page }

  describe "signup" do

    before { visit new_agent_registration_path }

    describe "page" do
      it { should have_selector "h1", text: "Register" }
    end

    describe "with invalid information" do
      it "should not create an agent" do
        expect { click_button "Register" }.not_to change(Agent, :count)
      end

      describe "after press" do
        before { click_button "Register" }
        it { should have_content "error" }
        pending "error messages"
      end

    end

    describe "with valid information" do

      before do
        @valid_information = FactoryGirl.attributes_for(:agent)

        fill_in "Name",                 with: @valid_information[:name]
        fill_in "Mobile",               with: @valid_information[:mobile]
        fill_in "Email",                with: @valid_information[:email]
        fill_in "Location",             with: @valid_information[:location]
        fill_in "Password",             with: @valid_information[:password]
        fill_in "Confirm",              with: @valid_information[:password]
      end

      it "should not create an agent" do
        expect { click_button "Register" }.to change(Agent, :count).by(1)
      end      

      describe "after press" do
        before { click_button "Register" }
        it { should flash_message "Welcome" }
      end

    end 

  end

  describe "profile" do

    let(:agent) { FactoryGirl.create(:agent) }
    before { visit agent_path(agent) }

    describe "page" do
      it { should have_selector "h1", text: agent.first_name }
      it { should have_selector "h2", text: agent.properties.count }
      it { should have_selector "p", text: agent.location }      
    end

  end

  describe "after save" do
    let(:agent) { FactoryGirl.create(:agent) }

    describe "login" do

      before { visit new_agent_session_path }
      
      describe "page" do
        it { should have_selector "h1", text: "Agent Login" }
      end

      describe "with invalid information" do
        before { click_button "Login" }
        it { should flash_message "Invalid" }
      end

      describe "with valid information" do
        before { valid_signin(agent) }
        it { should flash_message "Signed in" }
      end

    end
        
    describe "edit" do
      before do
        visit new_agent_session_path
        valid_signin(agent)
        visit edit_agent_registration_path
      end

      describe "page" do
        # it { save_and_open_page }
        it { should have_selector "h1", text: "Account Information" }
      end

      describe "with invalid information" do
        before do
          fill_in "Mobile",               with: "00000"
          click_button "Update" 
        end
        it { should have_content "error" }
      end

      describe "with valid information" do
        before do
          fill_in "Mobile",               with: "07" + Faker::Number.number(9)
          click_button "Update" 
        end
        it { should have_content "successfull" }
      end

    end
  end

end










