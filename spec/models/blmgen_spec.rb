require 'spec_helper'

describe Blmgen do

  before do
    binding.pry
    agency = FactoryGirl.create(:agency)
    agency.activate!
    agent = agency.agents.create(FactoryGirl.attributes_for(:agent))
    @valid_property = agent.properties.new(FactoryGirl.attributes_for(:property))
    binding.pry
    # @valid_property = Property.last
    # @blm = Blmgen.new(@valid_property._id)
  end

  subject { @blm }

  describe "attributes" do
    it do
      should respond_to :valid?,
                        :generate,
                        :image_zip
    end
    it { expect(@blm).to respond_to(:valid?) }
    it { expect(@blm).to respond_to(:generate).with(0).arguments }
    it { expect(@blm).to respond_to(:image_zip).with(1).arguments }
  end

  it { expect(@blm.valid?).to be_true }

  describe "property" do

    describe "invalid property_id" do
      it { expect(@blm.property('RANDOM_NON_ID')).to raise_error }
      it { pending "raise error, invalid id " }
    end

    describe "destroyed property" do
      before do
        dup = @valid_property.dup
        dup.save
        @dup_id = dup._id
        dup.destroy
      end
      it { expect(@blm.property(@dup_id)).to raise_error }
      it { pending "raise error, property not found " }
    end

    describe "incomplete property" do

      before do
        @incomplete_prop = @valid_property.dup
        @incomplete_prop.save
      end

      describe "missing available from date" do
        before do
          @incomplete_prop.available_from = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property available_from date missing " }
      end

      describe "images too small" do
        before do
          # need to know how to add this
          too_small_image = "small image"
          @incomplete_prop.images.first = too_small_image
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property image *name* too small" }
      end

      describe "images too large" do
        before do
          # need to know how to add this
          too_large_image = "large image"
          @incomplete_prop.images.first = too_large_image
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property image *name* too large" }
      end

      describe "missing address 1" do
        before do
          @incomplete_prop.ADDRESS_1 = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property ADDRESS_1 invalid" }
      end

      describe "missing address 2" do
        before do
          @incomplete_prop.ADDRESS_2 = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property ADDRESS_2 invalid" }
      end

      describe "missing TOWN" do
        before do
          @incomplete_prop.TOWN = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property TOWN invalid" }
      end

      describe "missing POSTCODE1" do
        before do
          @incomplete_prop.POSTCODE1 = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property POSTCODE1 invalid" }
      end

      describe "missing POSTCODE2" do
        before do
          @incomplete_prop.POSTCODE2 = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property POSTCODE2 invalid" }
      end

      describe "missing FEATURE1" do
        before do
          @incomplete_prop.FEATURE1 = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property FEATURE1 invalid" }
      end

      describe "missing FEATURE2" do
        before do
          @incomplete_prop.FEATURE2 = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property FEATURE2 invalid" }
      end

      describe "missing FEATURE3" do
        before do
          @incomplete_prop.FEATURE3 = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property FEATURE3 invalid" }
      end

      describe "missing SUMMARY" do
        before do
          @incomplete_prop.SUMMARY = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property SUMMARY invalid" }
      end

      describe "missing DESCRIPTION" do
        before do
          @incomplete_prop.DESCRIPTION = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property BRANCH_ID invalid" }
      end

      describe "missing BRANCH_ID" do
        before do
          @incomplete_prop.BRANCH_ID = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property BRANCH_ID invalid" }
      end

      describe "missing STATUS_ID" do
        before do
          @incomplete_prop.STATUS_ID = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property STATUS_ID invalid" }
      end

      describe "missing BEDROOMS" do
        before do
          @incomplete_prop.BEDROOMS = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property BEDROOMS invalid" }
      end

      describe "missing PRICE" do
        before do
          @incomplete_prop.PRICE = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property PRICE invalid" }
      end

      describe "missing PROP_SUB_ID" do
        before do
          @incomplete_prop.PROP_SUB_ID = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property PROP_SUB_ID invalid" }
      end

      describe "missing CREATE_DATE" do
        before do
          @incomplete_prop.CREATE_DATE = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property CREATE_DATE invalid" }
      end

      describe "missing UPDATE_DATE" do
        before do
          @incomplete_prop.UPDATE_DATE = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property UPDATE_DATE invalid" }
      end

      describe "missing DISPLAY_ADDRESS" do
        before do
          @incomplete_prop.DISPLAY_ADDRESS = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property DISPLAY_ADDRESS invalid" }
      end

      describe "missing TRANS_TYPE_ID" do
        before do
          @incomplete_prop.TRANS_TYPE_ID = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property TRANS_TYPE_ID invalid" }
      end

      describe "missing MEDIA_IMAGE" do
        before do
          @incomplete_prop.MEDIA_IMAGE = nill
          @incomplete_prop.save
        end
        it { expect(@blm.property(@incomplete_prop)).to raise_error }
        it { pending "raise error, property MEDIA_IMAGE invalid" }
      end

    end
  end
end
