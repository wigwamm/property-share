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
      :start_time,
      :time_on_site,
      :cookie_ident
    end    
  end
  
  it {should be_valid}
  
  describe 'defaults' do
    before { @result = Result.new }
    it('booked') { expect(@result.booked).to be_kind_of(FalseClass) }
    it('traveled_url') { expect(@result.traveled_urls).to be_kind_of(Array) }
    it('share_id') { expect(@result.share_id).to be_blank }
    it('time_on_site') { expect(@result.time_on_site).to be_kind_of(Float) }
    it('cookie_ident') { expect(@result.cookie_ident).to be_kind_of(String) }
  end

  describe 'Methods' do
    
    describe 'page change' do
      describe 'should recieve' do
        pending
      end
      describe 'when page is invalid' do 
        before { @result.add_current_url('anotherURL') }
        it('result') { expect(@result.traveled_urls.last).not_to be eq('anotherURL') }
      end
      describe 'when time is too long' do
        before do 
          @result.start_time = Time.now - 18000
          @result.add_current_url('http://propertyshare.io/test/')
        end
        it('time_on_site') { expect(@result.valid?).to be false }
      end
      describe 'when time is too short' do
        before do
          @traveled_urls_length = @result.traveled_urls.length
          @result.add_current_url('http://propertyshare.io/test/')
          @result.add_current_url('http://propertyshare.io/testing/')
          puts Time.now.to_f
          puts Time.now.to_f
        end
        it('traveled_urls') { expect(@result.traveled_urls.length).to be == (@traveled_urls_length + 1) }
      end
      describe 'when time zone changes' do
        pending
      end
      describe 'when added url is == to last' do
        before do
          @result.add_current_url('http://propertyshare.io/test/')
          @result.add_current_url('http://propertyshare.io/test/')
        end
        it('traveled_urls') { expect(@result.traveled_urls.last).not_to be eq(@result.traveled_urls[@result.traveled_urls.length-2]) }
      end
    end


    describe 'current_url' do
      before do
        @traveled_urls_length = @result.traveled_urls.length 
        @result.add_current_url('anotherURL')
      end
      
      describe 'add_current_url adds given string' do
        it('traveled_urls') { expect(@result.traveled_urls[@result.traveled_urls.length-1]).to eq('anotherURL') }
      end

      describe 'add_current_url is right length' do
        it('traveled_urls') { expect(@result.traveled_urls.length).to eq(@traveled_urls_length + 1) }
      end
    end
    
    describe 'time_on_site' do
      before do
        @result.add_current_url('asdf')
      end
      it('time_on_site') { expect(@result.time_on_site).to be_kind_of(Float) }
    end
  end
end
