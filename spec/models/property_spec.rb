require 'spec_helper'

describe Property do

  before(:all) {  Resque.remove_queue "property_queue" }

  before do
    FactoryGirl.create(:agent) do |agent|
      @property = FactoryGirl.build(:property, agent_id: agent.id)
    end
  end

  subject { @property }

  describe "model attributes" do
    it do
      should respond_to :title,
                        :description,
                        :property_type,
                        :price,
                        :price_unit,
                        :address,
                        :street,
                        :postcode,
                        :country,
                        :coordinates,
                        :active,
                        :assets_uuid,
                        :url,
                        :tiny_url,
                        :view_count,
                        :photo_count
    end
  end

  it { should be_valid }

  describe "defaults" do

    before { @property = Property.new }

    it("title") { expect(@property.title).to be_blank }
    it("description") { expect(@property.description).to be_blank }
    it("property_type") { expect(@property.property_type).to be_blank }
    it("price") { expect(@property.price).to be_blank }
    it("price_unit") { expect(@property.price_unit).to be_blank }
    it("street") { expect(@property.street).to be_blank }
    it("postcode") { expect(@property.postcode).to be_blank }
    it("country") { expect(@property.country).to eq("UK") }
    it("coordinates") { expect(@property.coordinates).to be_blank }
    it("active") { expect(@property.active).to be_false } 

    describe "assets uuid" do
      describe "should be a UUID of 36 characters" do
        it { expect(@property.assets_uuid).to be_kind_of(String) }
        it { expect(@property.assets_uuid.length).to be == 36 }
      end
    end

    it("url") { expect(@property.url).to be_blank }

    it("tiny url" ) { expect(@property.tiny_url).to be_blank }

    it("view_count") { expect(@property.view_count).to be == 0 }

    it("photo_count") { expect(@property.photo_count).to be == 0 }

  end

  describe "validations" do

    describe "title" do

      describe "if more than 100 characters" do
        before { @property.title = Faker::Lorem.characters(102) }
        it { should_not be_valid }
      end

      describe "if less than 100 characters" do
        before { @property.title = Faker::Lorem.characters(90) }
        it { should be_valid }
      end

      describe "if exactly 100 characters" do
        before { @property.title = Faker::Lorem.characters(100) }
        it { should be_valid }
      end

      describe "if blank" do
        before { @property.title = "" }
        it { should_not be_valid }
      end

    end

    describe "description" do

      describe "if blank" do
        before { @property.description = "" }
        it { should be_valid }
      end

    end

    describe "price" do

      describe "if less than 10" do
        before { @property.price = Faker::Number.number(1) }
        it { should_not be_valid }
      end

      describe "if blank" do
        before { @property.price = "" }
        it { should_not be_valid }
      end

    end

    describe "price_unit" do
      describe "if blank" do
        before { @property.price_unit = "" }
        it { should_not be_valid }
      end
    end

    describe "address" do

      describe "street" do
        describe "if blank" do
          before { @property.street = "" }
          it { should_not be_valid }
        end
      end

      describe "postcode" do
        describe "if blank" do
          before { @property.postcode = "" }
          it { should_not be_valid }
        end

        describe "with incorrect format" do
          before { @property.postcode = "NOOOPOST" }
          it { should_not be_valid }
        end
        describe "with long format" do
          before { @property.postcode = "EC4M 8AD" }
          it { should be_valid }
        end
        describe "with short format" do
          before { @property.postcode = "N4 3ET" }
          it { should be_valid }
        end
        describe "with lowercase format" do
          before { @property.postcode.downcase! }
          it { should be_valid }
        end
      end

    end

    describe "view_count" do
      it { expect(@property.view_count).to be == 0 }
    end

    describe "photo_count" do
      it { expect(@property.photo_count).to be <= 0 }
    end

  end

  describe "after save" do

    before() do 
      @property.save
    end

    let(:found_property) { Property.where(url: @property.url).first } 
    subject { found_property }

    describe "types" do
      it { expect(found_property.title).to be_kind_of(String) }
      it { expect(found_property.description).to be_kind_of(String) }
      it { expect(found_property.property_type).to be_kind_of(String) }
      it { expect(found_property.price).to be_kind_of(Integer) }
      it { expect(found_property.price_unit).to be_kind_of(String) }
      it { expect(found_property.street).to be_kind_of(String) }
      it { expect(found_property.country).to be_kind_of(String) }
      it { expect(found_property.postcode).to be_kind_of(String) }
      it { expect(found_property.country).to be_kind_of(String) }
      it { expect(found_property.coordinates).to be_kind_of(Array) }
      it { expect(found_property.active).to be_kind_of(FalseClass) }
      it { expect(found_property.assets_uuid).to be_kind_of(String) }
      it { expect(found_property.url).to be_kind_of(String) }
      # it { expect(found_property.tiny_url).to be_kind_of(String) }
      it { expect(found_property.view_count).to be_kind_of(Integer) }
      it { expect(found_property.photo_count).to be_kind_of(Integer) }
      it { expect(found_property.created_at).to be_kind_of(Time) }
      it { expect(found_property.updated_at).to be_kind_of(Time) }
    end

    describe "find_lat_long" do

      # describe "before call" do
      #   it { expect(@found_property.coordinates).to be_blank }
      # end
      
      # describe "when sucessfull" do
      #   before { @found_property.find_lat_long }
      #   describe "should add location info to coordinates" do
      #     it { expect(@found_property.coordinates).to_not be_blank }
      #     it { expect(@found_property.coordinates[0]).to be_kind_of(Float) }
      #     it { expect(@found_property.coordinates[1]).to be_kind_of(Float) }
      #   end
      # end
      
      #  Geocoder is ALWAYS returning a lat / long so validations won't work yet

      # describe "when unsuccessfull" do
      #   before do 
      #     @resque_count = Resque.info[:pending]
      #     @found_property.update_attributes(street: "no street ----", postcode: "XX00 0XX",  coordinates: [])
      #     @found_property.find_lat_long
      #   end

      #   describe "should not change coordinates" do
      #     it { expect(@found_property.coordinates).to be_empty }
      #   end            
      #   describe "should requeue a background task" do
      #     it { expect(@resque_count).to eq(@resque_count + 1) }
      #   end            
      #   describe "should raise an alert" do
      #     # before { @found_property.find_lat_long }
      #     pending
      #   end            
      # end
      
      # describe "with invalid street" do
      #   before do 
      #     @found_property.update_attributes(street: "no street ----", coordinates: [])
      #     @found_property.find_lat_long
      #   end
      #   it { expect(@found_property.coordinates).to be_kind_of(Array) }
      # end
      
      # describe "with invalid postcode" do
      #   before do 
      #     @found_property.update_attribute(:postcode, "XX00 0XX")
      #     @found_property.find_lat_long
      #   end
      #   it { expect(@found_property.coordinates).to be_empty }
      # end

    end
  end

end

#############################################
