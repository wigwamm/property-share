require 'spec_helper'

describe Availability do

  let(:agent) { FactoryGirl.create(:agent) }    

  before do
    FactoryGirl.create(:agent) do |agent|
      @availability = agent.availabilities.build(attributes_for(:availability))
    end
  end

  subject { @availability }

  describe "model attributes" do
    it do
      should respond_to :start_time,
                        :end_time,
                        :booked,
                        :created_at,
                        :created_by,
                        :updated_at,
                        :updated_by,
                        :agent_id
    end
  end

  it { should be_valid }

  describe "validations" do

    describe "start_time" do

      describe "if in the past" do
        before { @availability.start_time = Time.now - (rand(100) * rand(100)).minutes }
        it { should_not be_valid }
      end
      describe "if blank" do
        before { @availability.start_time = " " }
        it { should_not be_valid }
      end
      describe "if a dateTime" do
        before { @availability.start_time = DateTime.now + (rand(100) * rand(100)).minutes }
        it { should be_valid }
      end
      describe "if a string" do
        before { @availability.start_time = "Tuesday 12th at 12:40" }
        it { should_not be_valid }
      end
      describe "if null" do
        before { @availability.start_time = nil }
        it { should_not be_valid }
      end
    end
  end

  describe "after save" do
    describe "types" do
      before { @availability.save }

      let(:found_availability) { Availability.find(@availability.id) }

      it { expect(found_availability.start_time).to be_kind_of(Time) }
      it { expect(found_availability.end_time).to be_kind_of(Time) }
      it { expect(found_availability.booked).to be_kind_of(FalseClass) }
      it { expect(found_availability.created_by).to be_kind_of(String) }
      it { expect(found_availability.updated_by).to be_kind_of(String) }
      it { expect(found_availability.created_at).to be_kind_of(Time) }
      it { expect(found_availability.updated_at).to be_kind_of(Time) }
    end
  end

  describe "if already booked" do
    before do
      duped_availability = @availability.dup
      duped_availability.save
      @availability.save
    end
    it { should_not be_valid }
    it "should return an error" do
       expect(@availability.errors).to_not be_blank
    end
    # it "should return next availabile time" do
    #   expect(@availability.errors.next_time.class).to eq(DateTime)
    # end
  end

  describe "accept methods" do
    it do
      should respond_to :book!
    end
  end

end

#############################################
