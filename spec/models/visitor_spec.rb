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

#   describe "before save" do

#     describe "if name is not present" do
#       before { @visitor.name = ""}
#       it { should_not be_valid }
#     end

#     describe "if mobile is not present" do
#       before { @visitor.mobile = ""}
#       it { should_not be_valid }
#     end

#     describe "if registration_code is not present" do
#       before { @visitor.registration_code = ""}
#       it { should_not be_valid }
#     end

#     describe "if email is not present" do
#       before { @visitor.email = ""}
#       it { should be_valid }
#     end

#     describe "when password_confirmation doesn't match" do
#       before { @visitor.password_confirmation = @visitor.password[1..2] }
#       it { should_not be_valid }
#     end

#     describe "when password_confirmation is blank " do
#       before { @visitor.password_confirmation = "" }
#       it { should_not be_valid }
#     end

#     describe "when primary_contact is email" do 
#       before { @visitor.primary_contact = "email" }

#       describe "if email is blank" do
#         before { @visitor.email = " " }
#         it { should_not be_valid }
#       end

#       describe "if email is nil" do
#         before { @visitor.email = nil }
#         it { should_not be_valid }
#       end

#       describe "if mobile is blank" do
#         before { @visitor.mobile = " " }
#         it { should_not be_valid }
#       end

#       describe "if mobile is nil" do
#         before { @visitor.mobile = nil }
#         it { should_not be_valid }
#       end

#     end

#     describe "when primary_contact is unset" do 
#       it "should equal mobile" do
#         expect(@visitor.primary_contact).to eq("mobile")
#       end
#     end

#     describe "when email is invalid" do
#       before { @visitor.email = "bademail" }
#       it { should_not be_valid }
#     end

#     describe "when mobile is invalid" do
#       before { @visitor.mobile = "0010919" }
#       it { should_not be_valid }
#     end

#     describe "when email address is already taken" do
#       before do
#         @visitor_with_same_email = FactoryGirl.build(:agent)
#         @visitor_with_same_email.email = @visitor.email.upcase
#         @visitor_with_same_email.save
#       end
#       it { should_not be_valid }
#     end

#     describe "when mobile is already taken" do

#       before do
#         @visitor_with_same_mobile = FactoryGirl.build(:agent) 
#         @visitor_with_same_mobile.mobile = @visitor.mobile
#         @visitor_with_same_mobile.save
#       end
#       it { should_not be_valid }

#     end

#   end

#   #############################
#   ### =>  After Save

#   describe "After Save" do

#     before { @visitor.save }
#     let(:found_agent) { Agent.where(email: @visitor.email).first }

#     describe "has encrypted password" do
#       it { found_agent.encrypted_password.should_not be_nil }
#     end

#     describe "is not active" do

#       describe "has inactive status" do
#         it { found_agent.mobile_active.should be_false }
#       end

#       describe "has inactivated dates" do
#         it { found_agent.mobile_activated_at.should be_nil }
#       end
#     end

#   end

#   describe "After Mobile Activation" do 

#     before { @visitor.activate!("mobile") }
#     let(:found_agent) { Agent.where(email: @visitor.email).first }

#     it { found_agent.mobile_active.should be_true }
#     it { found_agent.mobile_activated_at.should_not be_nil }
#     it { found_agent.mobile_activated_at.class == DateTime }

#   end


end

#############################################
