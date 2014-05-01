require 'spec_helper'

describe Image do

  before do
    FactoryGirl.create(:agent) do |agent|
      @property = FactoryGirl.build(:property, agent_id: agent.id)
      @image = @property.images.new(attributes_for(:image))
    end
  end

  subject { @image }

  it { should be_embedded_in(:property) }

  describe "model attributes" do
    it do
      should respond_to :title,
                        :position,
                        :direct_upload_url,
                        :main_image,
                        :processed,
                        :created_at,
                        :updated_at
    end
  end

  it { should be_valid }

  describe "defaults" do

    before { @image = Image.new }

    it("title") { expect(@image.title).to be_blank }
    it("position") { expect(@image.position).to be_blank }
    it("direct_upload_url") { expect(@image.direct_upload_url).to be_blank }
    it("main_image") { expect(@image.main_image).to be_false }
    it("processed") { expect(@image.processed).to be_false }

  end

  it { should respond_to :photo }

  describe "validations" do

    describe "direct_upload_url" do
    
      describe "when direct_upload_url is nil" do
        before { @image.direct_upload_url = nil }
        it { should_not be_valid }    
      end
      describe "when direct_upload_url is blank" do
        before { @image.direct_upload_url = " " }
        it { should_not be_valid }    
      end      
      describe "when direct_upload_url is not valid" do
        before { @image.direct_upload_url = "https://nots3.amazonaws.com/propertyshare-test/tmp/uploads/1396604841693-6gze8g7k9t6s9k9-031f25e6c835451a524469b215f272dc/1882_BTS102586_IMG_00.jpg" }
        it { should_not be_valid }    
      end
      
    end

    describe "title" do

      describe "when title is blank" do
        before { @image.title = " " }
        it { should be_valid }    
      end

    end

    describe "position" do

      describe "when position is blank" do
        before { @image.position = " " }
        it { should be_valid }    
      end

    end

    describe "title" do

      describe "when title is blank" do
        before { @image.title = " " }
        it { should be_valid }    
      end

    end

  end


end

#############################################
