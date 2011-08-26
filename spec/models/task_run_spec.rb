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
    before(:each) do
      @run = TaskRun.new()
      @text = "This trackable task is cool"
    end

    it "should take one parameter" do
      @run.method(:add_log_text).arity.should == 1
    end

    it "should add a newline after the input text" do
      @run.add_log_text(@text)
      @run.log_text.should == (@text + "\n")
    end

    it "should save the string to the log_text if it is empty" do
      @run.add_log_text(@text)
      @run.log_text.should match @text
    end
    
    it "should append the string to the text if it is not empty" do
      original_text = "first log text"
      @run.log_text = original_text
      @run.add_log_text(@text)
      @run.log_text.should match original_text
      @run.log_text.should match @text
    end

  end

  describe "add_error_text method" do
    before(:each) do
      @run = TaskRun.new()
      @text = "This trackable task is erroring"
    end

    it "should take one parameter" do
      @run.method(:add_error_text).arity.should == 1
    end

    it "should add a newline after the input text" do
      @run.add_error_text(@text)
      @run.error_text.should == (@text + "\n")
    end

    it "should save the string to the error_text if it is empty" do
      @run.add_error_text(@text)
      @run.error_text.should match @text
    end
    
    it "should append the string to the text if it is not empty" do
      original_text = "first log text"
      @run.error_text = original_text
      @run.add_error_text(@text)
      @run.error_text.should match original_text
      @run.error_text.should match @text
    end
  end
end
