require 'spec_helper'

describe Agreement do

  before do
    agent = FactoryGirl.create(:agent)
    visitor = FactoryGirl.create(:visitor)
    @agreement = FactoryGirl.build(:agreement, gentleman_id: agent.id.to_s, courter_id: visitor.id.to_s )
  end

  subject { @agreement }

  it do
    should respond_to :gentleman_id,
                      :courter_id,
                      :token,
                      :action,
                      :args,
                      :complete,
                      :expired,
                      :created_at,
                      :updated_at,
                      :handshake,
                      :settle
  end

  it { should be_valid }

  describe "before handshake" do

    describe "if gentleman_id is not present" do
      before { @agreement.gentleman_id = "" }
      it { should_not be_valid }
    end

    describe "if gentleman_id doesn't match a user" do
      before { @agreement.gentleman_id = "skjbsbh"}  
      it { should_not be_valid }
    end
    
    describe "if courter_id is not present" do
      before { @agreement.courter_id = "" }
      it { should_not be_valid }
    end

    describe "if courter_id doesn't match a user" do
      before { @agreement.courter_id = "skjbsbh" }
      it { should_not be_valid }
    end

    describe "if the agent is deleted" do
      before do
        agent = FactoryGirl.create(:agent)
        @agreement.gentleman_id = agent.id.to_s
        agent.destroy
      end
      it { should_not be_valid }
    end

    describe "if the visitor is deleted" do
      before do
        visitor = FactoryGirl.create(:visitor)
        @agreement.gentleman_id = visitor.id.to_s
        visitor.destroy
      end
      it { should_not be_valid }
    end

  end

  describe "after save" do
    before do 
      @agreement_count = Agreement.all.count
      @agreement.save
    end

    describe "it should save to the database" do
      it { expect(@agreement_count + 1).to be == Agreement.all.count }
    end

    describe "its token" do
      it { @agreement.token.should_not be_blank }
      it { expect(@agreement.token.length).to be <= 2 }
    end
    
    describe "Handshake" do

      before do
        # Add test action
        class Agreement
          protected
          def test(subject, run, args)
            return { run: run, args: args }
          end
        end
      end

      describe "accepts actions" do
        
        it "test action" do
          allow(@agreement).to receive(:handshake).with("test", {})
        end

        describe "valid action" do
          it { expect(@agreement.handshake("test", {})).to be_true }
        end
        describe "valid action" do
          it { expect(@agreement.handshake("invalid action", {})).to_not be_true }
        end
      end
    end

    describe "Settle" do

      before do
        # Add test action
        class Agreement
          protected
          def test(subject, run, args)
            return { run: run, args: args }
          end
        end
      end

      let(:found_agreement) { Agreement.find(@agreement.id) }
      let(:found_agent) { Agent.find(found_agreement.gentleman_id) }
      let(:found_user) { User.find(found_agreement.courter_id) }


      # describe "subject" do
        
      #   describe "Agent" do
      #     it { expect(@agreement.settle("test", {})).to be_true }
      #   end
      #   describe "valid action" do
      #     it { expect(@agreement.settle("invalid action", {})).to_not be_true }
      #   end
      # end

    end

  end

end

#############################################
