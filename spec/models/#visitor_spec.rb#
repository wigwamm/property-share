require 'spec_helper'

describe Visitor do

  before do
    @visitor = FactoryGirl.build(:visitor)
  end

  subject { @visitor }

  it do
    should respond_to :mobile,
                      :mobile_active,
                      :mobile_activated_at,
                      :name,
                      :first_name,
                      :last_name,
                      :other_names,
                      :created_at,
                      :updated_at
  end

  it { should be_valid }

  describe "before save" do

    describe "if mobile is not present" do
      before { @visitor.mobile = ""}
      it { should_not be_valid }
    end

    describe "when mobile is invalid" do
      before { @visitor.mobile = "0010919" }
      it { should_not be_valid }
    end

    describe "when mobile is already taken" do

      before do
        @visitor_with_same_mobile = FactoryGirl.build(:visitor) 
        @visitor_with_same_mobile.mobile = @visitor.mobile
        @visitor_with_same_mobile.save
      end
      it { should_not be_valid }

    end

  end

  #############################
  ### =>  After Save

  describe "After Save" do

    before { @visitor.save }
    let(:found_visitor) { Visitor.where(mobile: @visitor.mobile).first }

  end

  describe "After Mobile Activation" do 

    before { @visitor.activate!("mobile") }
    let(:found_visitor) { Visitor.where(mobile: @visitor.mobile).first }

    it { found_visitor.mobile_active.should be_true }
    it { found_visitor.mobile_activated_at.should_not be_nil }
    it { found_visitor.mobile_activated_at.class == DateTime }

  end


end

#############################################
