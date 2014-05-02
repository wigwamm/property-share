require 'spec_helper'

describe "Property Pages" do

  subject { page }

  describe "when signed in" do

    let(:agent) { FactoryGirl.create(:agent) }        
    before do
      visit new_agent_session_path
      valid_signin(agent)
    end

    describe "new" do

      before { visit new_property_path }

      describe "page" do
        it { should have_selector "li.target", text: "Property Infor" }
        it { should have_selector ".property_form" }  

        it { should_not have_selector "ul.progress" }

        it { should_not have_selector "div.form_wrapper" }
        it { should_not have_selector "div.form_group" }

        it { pending "check for google map" }
        it { pending "check for description" }
        it { pending "check for " }

      end

      describe "with invalid information" do
        it "should NOT create a property" do
          expect{ click_button "Add Photos" }.not_to change(Property, :count)
        end

        describe "after press" do
          before { click_button "Add Photos" }
          it { should have_content "error" }
        end
      end

      describe "with valid information" do

        before do
          @valid_information = FactoryGirl.attributes_for(:property)
          fill_in "Title",                with: @valid_information[:title]
          fill_in "Description",          with: @valid_information[:description]
          fill_in "Sales or Rental",      with: @valid_information[:property_type]
          fill_in "Price",                with: @valid_information[:price]
          fill_in "Price Unit",           with: @valid_information[:price_unit]
          fill_in "Address",              with: @valid_information[:street]
          fill_in "Postcode",             with: @valid_information[:postcode]
        end

        it "should create a property" do
          expect{ click_button "Add Photos" }.to change(Property, :count).by(1)
        end

        describe "after press" do
          before { click_button "Add Photos" }
          it { should flash_message "add photos" }
        end

      end

      describe "property" do

        let(:property) { agent.properties.create(FactoryGirl.attributes_for(:property)) }
        it { expect(property.active).to be_false }

        describe "edit page" do
          before { visit pending_property_path(property) }

          describe "page" do
            # it { save_and_open_page }
            it { should have_selector "h1", text: property.title }
            it { should have_selector "h2", text: "£#{property.price}" }
            it { should have_selector "p", text: property.description }

            it { should_not have_selector "ul.progress" }

            it { should_not have_selector "div.form_wrapper" }
            it { should_not have_selector "div.form_group" }
                
            it "has an image upload form" do
              within("form#s3_uploader") do
                should have_selector "h1", text: "Drop Images Here"
                should have_selector "div.add_images"
              end
            end

            it "has an image upload form" do
              within("form") do
                should have_selector "div#images_upload"
                should have_selector "input#hidden_file_input"
              end
            end
          end

          describe "can upload an image" do
            before { expect{ attach_file "file", "./spec/files/property/image2.jpg" }
            it { click_button "Add Images" }.to change(property.images, :count).by(1)  }
          end

          describe "with invalid information" do
            describe "large image" do
              before { expect{ attach_file "file", "./spec/files/too_large.jpg" }
              it { click_button "Add Images" }.not_to change(property.images, :count).by(1)  }              
            end
          end

          describe "with valid information" do
            before do 
              attach_file "file", "./spec/files/property/image2.jpg"
              click_button "Add Images"
              visit property_path(property)
            end
          end

        end

      end

    end
  end




  
end