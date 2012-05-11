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

  describe "today scope" do
    before(:each) do
      @today = TrackableTasks::TaskRun.create!(:task_type => "test task", :start_time => 5.hours.ago, :end_time => 3.hours.ago, :success => true)
      @yesterday = TrackableTasks::TaskRun.create!(:task_type => "test task", :start_time => 30.hours.ago, :end_time => 29.hours.ago, :success => true)
    end

    it "should include today" do
      TrackableTasks::TaskRun.today.should include @today
    end

    it "should not include yesterday" do
      TrackableTasks::TaskRun.today.should_not include @yesterday
    end
  end

  describe "this_week scope" do
    before(:each) do
      @this_week= TrackableTasks::TaskRun.create!(:task_type => "test task", :start_time => 5.days.ago, :end_time => 3.days.ago, :success => true)
      @older = TrackableTasks::TaskRun.create!(:task_type => "test task", :start_time => 30.days.ago, :end_time => 29.days.ago, :success => true)
    end

    it "should include this week" do
      TrackableTasks::TaskRun.this_week.should include @this_week
    end

    it "should not include older" do
      TrackableTasks::TaskRun.this_week.should_not include @older
    end
  end

  describe "newest_first_scope" do
    before(:each) do
      @today = TrackableTasks::TaskRun.create!(:task_type => "test task", :start_time => 5.hours.ago, :end_time => 3.hours.ago, :success => true)
      @yesterday = TrackableTasks::TaskRun.create!(:task_type => "test task", :start_time => 30.hours.ago, :end_time => 29.hours.ago, :success => true)
    end

    it "today should be first" do
      TrackableTasks::TaskRun.newest_first.first.should == @today
    end

    it "yesterday should be last" do
      TrackableTasks::TaskRun.newest_first.last.should == @yesterday
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
  
  describe "status_color method" do
    before(:each) do
      @run = TaskRun.new()      
    end
    
    it "should return green if success is true and error_text is empty (nil)" do
      @run.success = true
      @run.error_text = nil
      @run.status_color.should == "green"  
    end
    
    it "should return yellow if success is true but there is error_text" do
      @run.success = true
      @run.error_text = "Error text"
      @run.status_color.should == "yellow"
    end
    
    it "should return red if success is false" do
      @run.success = false
      @run.status_color.should == "red"      
    end        
  end
  
  describe "display_run_time method" do
    before(:each) do
      @run = TaskRun.new()      
    end    

    it "should call run_time_or_time_elapsed" do
      @run.should_receive(:run_time_or_time_elapsed).and_return(Time.now)
      @run.end_time = Time.now
      @run.display_run_time
    end
    
    it "should return the time formatted in hours, minutes and seconds if end_time is true" do
      @run.start_time = Time.at(3)
      @run.end_time = Time.at(946702800)
      @run.display_run_time.should == Time.at(@run.end_time - @run.start_time).gmtime.strftime('%R:%S')       
    end
    
    it "should return a string 'Run has not completed' if end_time is false" do
      @run.end_time = false
      @run.display_run_time.should == "Run has not completed."
    end    
  end

end
