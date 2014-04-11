require 'spec_helper'

describe Agent do

  before do
    @agent = FactoryGirl.build(:agent)
  end

  subject { @agent }

  it do
    should respond_to :type,
                      :admin,
                      :name,
                      :first_name,
                      :last_name,
                      :other_names,
                      :registration_code,
                      :mobile,
                      :email,
                      :primary_contact,
                      :twitter,
                      :facebook,
                      :created_at,
                      :updated_at
  end

  it { should be_valid }

  describe "before save" do

    describe "if name is not present" do
      before { @agent.name = ""}
      it { should_not be_valid }
    end

    describe "if mobile is not present" do
      before { @agent.mobile = ""}
      it { should_not be_valid }
    end

    describe "if registration_code is not present" do
      before { @agent.registration_code = ""}
      it { should_not be_valid }
    end

    describe "if email is not present" do
      before { @agent.email = ""}
      it { should be_valid }
    end

    describe "when password_confirmation doesn't match" do
      before { @agent.password_confirmation = @agent.password[1..2] }
      it { should_not be_valid }
    end

    describe "when password_confirmation is blank " do
      before { @agent.password_confirmation = "" }
      it { should_not be_valid }
    end

    describe "when primary_contact is email" do 
      before { @agent.primary_contact = "email" }

      describe "if email is blank" do
        before { @agent.email = " " }
        it { should_not be_valid }
      end

      describe "if email is nil" do
        before { @agent.email = nil }
        it { should_not be_valid }
      end

      describe "if mobile is blank" do
        before { @agent.mobile = " " }
        it { should_not be_valid }
      end

      describe "if mobile is nil" do
        before { @agent.mobile = nil }
        it { should_not be_valid }
      end

    end

    describe "when primary_contact is unset" do 
      it "should equal mobile" do
        expect(@agent.primary_contact).to eq("mobile")
      end
    end

    describe "when email is invalid" do
      before { @agent.email = "bademail" }
      it { should_not be_valid }
    end

    describe "when mobile is invalid" do
      before { @agent.mobile = "0010919" }
      it { should_not be_valid }
    end

    describe "when email address is already taken" do
      before do
        @agent_with_same_email = FactoryGirl.create(:agent, email: @agent.email)
      end
      it { should_not be_valid }
    end

    describe "when mobile is already taken" do

      before do
        @agent_with_same_mobile = FactoryGirl.build(:agent) 
        @agent_with_same_mobile.mobile = @agent.mobile
        @agent_with_same_mobile.save
      end
      it { should_not be_valid }

    end

  end

  #############################
  ### =>  After Validation

  describe "After Validation" do
    describe "when name has two parts" do
      before do 
        @agent = FactoryGirl.build(:agent, name: "Double Name")
        @agent.valid?
      end

      it "should have a first name" do 
        @agent.first_name.should_not be_empty
      end

      it "should have a last name" do 
        @agent.last_name.should_not be_empty
      end

    end

    describe "when name has three parts" do

      before do 
        @agent = FactoryGirl.build(:agent, name: "Billy The Kid")
        @agent.valid?
      end

      it "should have a first name" do 
        @agent.first_name.should_not be_empty
      end

      it "should have other names" do 
        @agent.other_names.should_not be_empty
      end

      it "should have a last name" do 
        @agent.last_name.should_not be_empty
      end

    end

  end

  #############################
  ### =>  After Save

  describe "After Save" do

    before { @agent.save }
    let(:found_agent) { Agent.where(mobile: @agent.mobile).first }


    describe "has encrypted password" do
      it { found_agent.encrypted_password.should_not be_nil }
    end

    describe "is not active" do

      describe "has inactive status" do
        it { found_agent.mobile_active.should be_false }
      end

      describe "has inactivated dates" do
        it { found_agent.mobile_activated_at.should be_nil }
      end
    end

  end

  describe "After Mobile Activation" do 

    before { @agent.activate!("mobile") }
    let(:found_agent) { Agent.where(email: @agent.email).first }

    it { found_agent.mobile_active.should be_true }
    it { found_agent.mobile_activated_at.should_not be_nil }
    it { found_agent.mobile_activated_at.class == DateTime }

  end


end

#############################################
