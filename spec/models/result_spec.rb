require 'spec_helper'

describe Result do
  before do
    @agent = FactoryGirl.build(:agent)
    @share = @agent.shares.new(FactoryGirl.attributes_for(:share))
    @result = @share.results.new(FactoryGirl.attributes_for(:result))
  end
  
  subject { @result }
  
  describe 'Attributes' do
    it do
      should respond_to :booked,
      :traveled_urls,
      :share_id,
      :time_on_site
    end    
  end
  
  it {should be_valid}
  
  describe 'defaults' do
    before { @result = Result.new }
    it('booked') { expect(@result.booked).to be_kind_of(FalseClass) }
    it('traveled_url') { expect(@result.traveled_urls).to be_kind_of(Array) }
    it('share_id') { expect(@result.share_id).to be_blank }
    it('time_on_site') { expect(@result.time_on_site).to be_kind_of(Float) }
    it('time_on_site') { expect(@result.time_on_site).to be == 0.0 }
  end

  describe 'validations' do
    #What validations do I need?
  end
  
end
