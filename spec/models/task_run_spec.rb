require 'spec_helper'
include TrackableTasks

describe TaskRun do
  describe "validations" do
    before(:each) do
      @valid_attributes = {
        :start_time => Time.now,
        :task_type => "my_task",
        :success => false
      }
      @run = TaskRun.new()
    end

    it "should be valid" do
      @run.attributes = @valid_attributes
      @run.should be_valid
    end

    it "should require task type" do
      @run.should have(1).error_on(:task_type)
    end
    
    it "should require start time" do
      @run.should have(1).error_on(:start_time)
    end
    
    it "should require success" do
      @run.success = nil
      @run.should have(1).error_on(:success)
    end

    it "should default to success = false" do
      @run.success.should == false
      @run.should have(0).error_on(:success)
    end

    it "end time should be after start time" do
    end
  end

  describe "add_log_text method" do
  end

  describe "add_error_text method" do
  end
  
end
