# require 'spec_helper'

# describe Agent do

#   before do
#     @agent = FactoryGirl.build(:agent)
#   end

#   subject { @agent }

#   it do
#     should respond_to :email, 
#                       :mobile, 
#                       :name, 
#                       :agency,
#                       :twitter,
#                       :password,
#                       :password_hash,
#                       :remember_token,
#                       :remember_token_expires_at,
#                       :reset_token,
#                       :primary_contact,
#                       :email_active,
#                       :email_activation_code,
#                       :email_activated_at,
#                       :mobile_active,
#                       :mobile_activation_code,
#                       :mobile_activated_at,
#                       :sign_in_count,
#                       :current_sign_in_at,
#                       :last_sign_in_at,
#                       :current_sign_in_ip,
#                       :last_sign_in_ip,
#                       :created_at,
#                       :updated_at
#   end

#   it { should be_valid }

#   describe "before save" do

#     describe "if name is not present" do
#       before { @agent.name = ""}
#       it { should_not be_valid }
#     end

#     describe "if mobile is not present" do
#       before { @agent.mobile = ""}
#       it { should_not be_valid }
#     end

#     describe "if email is not present" do
#       before { @agent.email = ""}
#       it { should be_valid }
#     end

#     describe "when primary_contact is email" do 
#       before { @agent.primary_contact = "email" }

#       describe "if email is blank" do
#         before { @agent.email = " " }
#         it { should_not be_valid }
#       end

#       describe "if email is nil" do
#         before { @agent.email = nil }
#         it { should_not be_valid }
#       end

#       describe "if mobile is blank" do
#         before { @agent.mobile = " " }
#         it { should be_valid }
#       end

#       describe "if mobile is nil" do
#         before { @agent.mobile = nil }
#         it { should be_valid }
#       end

#     end

#     describe "when primary_contact is unset" do 
#       it "should equal mobile" do
#         expect(@agent.primary_contact).to eq("mobile")
#       end
#     end

#     describe "when email is invalid" do
#       before { @agent.email = "bademail" }
#       it { should_not be_valid }
#     end

#     describe "when mobile is invalid" do
#       before { @agent.mobile = "0010919" }
#       it { should_not be_valid }
#     end

#     describe "when email address is already taken" do
#       before do
#         @agent_with_same_email = FactoryGirl.build(:agent)
#         @agent_with_same_email.email = @agent.email.upcase
#         @agent_with_same_email.save
#       end
#       it { should_not be_valid }
#     end

#     describe "when mobile is already taken" do

#       before do
#         @agent_with_same_mobile = FactoryGirl.build(:agent) 
#         @agent_with_same_mobile.mobile = @agent.mobile
#         @agent_with_same_mobile.save
#       end
#       it { should_not be_valid }

#     end

#     describe "when password_confirmation doesn't match" do
#       before { @agent.password_confirmation = @agent.password[1..2] }
#       it { should_not be_valid }
#     end

#     describe "when password_confirmation is nil " do
#       before { @agent.password_confirmation = nil }
#       it { should_not be_valid }
#     end

#     describe "when password_confirmation is nil " do
#       before { @agent.password_confirmation = nil }
#       it { should_not be_valid }
#     end

#   end

#   #############################
#   ### =>  After Save

#   describe "After Save" do

#     before { @agent.save }
#     let(:found_agent) { Agent.where(email: @agent.email).first }

#     describe "with valid password" do
#       it "should equal authenticated agent" do
#         expect(found_agent).to eq(Agent.authenticate(@agent.email, @agent.password))
#       end
#     end

#     describe "with invalid password" do
#       it "should not equal authenticated agent" do
#         expect(found_agent).not_to eq(Agent.authenticate(@agent.email, " "))
#       end
#     end

#     describe "has encrypted password" do
#       it "including password hash " do
#         found_agent.password_hash.should_not be_nil
#       end
#       it "including password salt " do
#         found_agent.password_salt.should_not be_nil
#       end
#     end

#     describe "has activation codes" do
#       it "including mobile activation code" do 
#         found_agent.mobile_activation_code.should_not be_nil
#       end
#       it "including email activation code" do
#         found_agent.email_activation_code.should_not be_nil
#       end
#     end

#     describe "is not active" do

#       describe "has inactive status" do
#         it { found_agent.mobile_active.should be_false }
#         it { found_agent.email_active.should be_false }
#       end

#       describe "has inactivated dates" do
#         it { found_agent.mobile_activated_at.should be_nil }
#         it { found_agent.email_activated_at.should be_nil }
#       end
#     end

#   end

#   describe "After Mobile Activation" do 

#     before { @agent.activate!("mobile") }
#     let(:found_agent) { Agent.where(email: @agent.email).first }

#     it { found_agent.mobile_active.should be_true }
#     it { found_agent.mobile_activated_at.should_not be_nil }
#     it { found_agent.mobile_activated_at.class == DateTime }

#   end

#   describe "After Email Activation" do 
#     before { @agent.activate!("email") }
#     let(:found_agent) { Agent.where(email: @agent.email).first }
 
#     it { found_agent.email_active.should be_true }
#     it { found_agent.email_activated_at.should_not be_nil }
#     it { found_agent.email_activated_at.class == DateTime }
#   end

#   describe "has remember token" do
#     before { @agent.remember_me }
#     it { @agent.remember_token_expires_at.should >= DateTime.now }
#   end

#   describe "remember token should change" do
#     before do
#       @agent.remember_me
#       @token = @agent.remember_token
#       @agent.remember_me
#     end
#     it { @agent.remember_token.should_not == @token }
#   end


# end

# #############################################
