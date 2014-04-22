require 'spec_helper'

describe Share do
  
  before do
    @agent = FactoryGirl.build(:agent)
    @share = @agent.shares.new(FactoryGirl.attributes_for(:share))
  end
  
  subject{ @share }
  
  describe 'Attributes' do
    it do
      should respond_to :share_token,
      :refer_url,
      :agent_id,
      :property_id,
      :created_at,
      :updated_at
    end
  end

  it 'Methods' do 
    should respond_to :share_url 
  end

  it {should be_valid}

  describe 'validataions' do
    describe 'if property_id is not present' do
      before { @share.property_id = '' }
      it { should_not be_valid }
    end
    
    describe 'if agent_id is not present' do
      before { @share.agent_id = '' }
      it { should_not be_valid }
    end
    
    describe 'if page_url is not present' do
      before { @share.refer_url = '' }
      it { should_not be_valid }
    end

  end

  #describe "if mobile is not present" do
   # before { @visitor.mobile = ""}
    #it { should_not be_valid }
  #end

end
