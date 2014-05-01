require 'spec_helper'

describe Visit do

  before(:all) do
    FactoryGirl.create(:agent) do |agent|
      @availability = agent.availabilities.create(attributes_for(:availability))
      @property = agent.properties.create(attributes_for(:property))
    end
  end

  before do
    @visit = @property.visits.new(FactoryGirl.attributes_for(:visit, agent_id: @property.agent_id, start_time: @availability.start_time + 1.minute, start_time: @availability.end_time - 1.minute ))
  end

  subject { @visit }

  describe "model attributes" do
    it do
      should respond_to :start_time,
                        :end_time,
                        :confirmed,
                        :created_at,
                        :updated_at,
                        :agent_id,
                        :visitor_id,
                        :property_id
    end
  end

  it { should be_valid }

  describe "validations" do

    describe "start_time" do

      describe "if in the past" do
        before { @visit.start_time = Time.now - (rand(100) * rand(100)).minutes }
        it { should_not be_valid }
      end
      describe "if blank" do
        before { @visit.start_time = " " }
        it { should_not be_valid }
      end
      describe "if a dateTime" do
        before { @visit.start_time = DateTime.parse(@visit.start_time.to_s) }
        it { should be_valid }
      end
      describe "if a string" do
        before { @visit.start_time = "Tuesday 12th at 12:40" }
        it { should_not be_valid }
      end
      describe "if null" do
        before { @visit.start_time = nil }
        it { should_not be_valid }
      end
    end

    describe "end_time" do

      describe "if in the past" do
        before { @visit.end_time = Time.now - (rand(100) * rand(100)).minutes }
        it { should_not be_valid }
      end
      describe "if after start_time" do
        before { @visit.end_time = @visit.start_time - (rand(100) * rand(100)).minutes }
        it { should_not be_valid }
      end
      describe "if blank" do
        before { @visit.end_time = " " }
        it { should be_valid }
      end
      describe "if a dateTime" do
        before { @visit.end_time = DateTime.parse((@visit.start_time + 30.minutes).to_s) }
        it { should be_valid }
      end
      describe "if a string" do
        before { @visit.end_time = "Tuesday 12th at 12:40" }
        it { should_not be_valid }
      end
      describe "if null" do
        before { @visit.end_time = nil }
        it { should be_valid }
      end
    end
  end

  describe "after save" do
    before { @visit.save }

    describe "availability remainder" do
      
      describe "if 20 minutes or more" do
        pending "split into new chunks"        
      end

      describe "if less than 20 minutes" do
        pending "set as unused"
      end

    end

    describe "availability reminders" do
      
      describe "if in less than 1.30 hour" do
        pending "DONT add reminder to resque"
      end

      describe "if in more than 1.30 hour" do
        pending "add reminder to resque"
      end

    end

  end

end

#############################################
