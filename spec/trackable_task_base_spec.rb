require 'spec_helper'

describe TrackableTasks::Base do
  describe "initialize method" do
    before(:each) do 
      @mt = MyTask.new
    end

    it "should create a task run instance" do
      TrackableTasks::TaskRun.all.length.should == 1
    end

    it "should set the start time" do
      @mt.task_run.start_time.should_not be_nil
    end

    it "should set the type" do
      @mt.task_run.task_type.should == "MyTask"
    end
    
    it "should be successful" do
      # it should be successful on initialization
      @mt.task_run.success.should be_true
    end

    it "should default to notice if no log level is set" do
      # this awesome piece of code adds a method to @mt on the fly so I can
      # access the log_level instance variable
      # I am pretty sure this is the wrong way to do things
      def @mt.log_level
        @log_level
      end
      @mt.log_level.should == :notice
    end
  end

  describe "allowable_log_level method" do
    before(:each) do
      @mt = MyTask.new
    end

    it "should change the log level to notice if not an allowable level" do
      @mt.allowable_log_level(:illegal_level).should == :notice
    end

    it "should not change the level if it is allowable" do
      @mt.allowable_log_level(:notice).should == :notice
    end

    it "should convert the input to a symbol before comparing it against the allowable log levels"
  end

  describe "run_task" do
    before(:each) do 
      @mt = MyTask.new
    end

    it "should call the run method" do
      @mt.should_receive(:run)
      @mt.run_task
    end

    it "should be successful if no errors were raised" do
      @mt.run_task
      @mt.task_run.success.should be_true
    end

    it "should handle errors from the run method by saving them to the error log" do
      @erroring_task = ErroringTask.new
      @erroring_task.run_task
      @task_run = TrackableTasks::TaskRun.last
      @task_run.error_text.should match ""
    end

    it "should not be successful if any errors were raised" do
      @erroring_task = ErroringTask.new
      @erroring_task.run_task
      @task_run = TrackableTasks::TaskRun.last
      @task_run.success.should be_false
    end
  end

  describe "run method" do
    it "should error if it isn't overriden" do
      @t = TaskWithoutRun.new
      @t.run_task
      @task_run = TrackableTasks::TaskRun.last
      @task_run.error_text.should match "The run method must be overridden"
      @task_run.error_text.should match "NotImplementedError"
    end
  end

  describe "log method" do
    before(:each) do 
      @mt = MyTask.new
    end

    it "should take one argument" do
      # I don't know why this is -2
      # Maybe we should just remove this test
      @mt.method(:log).arity.should == -2
    end

    it "should call the task run's add_log_text method" do
      @mt.log("test log text")
      @mt.run_task
      @mt.task_run.log_text.should match "test log text"
    end

    it "should default to a log level of notice" do
      @mt = MyTask.new(:error)
      @mt.log("text that shouldn't be saved")
      @mt.task_run.log_text.should be_nil
    end

    it "should call allowable_log_level" do
      @mt.should_receive(:allowable_log_level).and_return(:notice)
      @mt.log("some random text")
    end

    # test each of the three log levels to see if it saves at the correct time
    it "should save debug logs if the log level is set to debug" do
      # whether or not to save at each of the levels
      levels = { :debug => true, :notice => false, :error => false }
      levels.each_pair do |level, save|
        @mt = MyTask.new(level)
        @mt.log("some debugging text", :debug)
        if save
          @mt.task_run.log_text.should match "some debugging text"
        else
          @mt.task_run.log_text.should be_nil
        end
      end
    end

    it "should save notice logs if the log level is debug or notice" do
      levels = { :debug => true, :notice => true, :error => false }
      levels.each_pair do |level, save|
        @mt = MyTask.new(level)
        @mt.log("some debugging text", :notice)
        if save
          @mt.task_run.log_text.should match "some debugging text"
        else
          @mt.task_run.log_text.should be_nil
        end
      end
    end

    it "should save error logs to the task run's error log on any level" do
      levels = { :debug => true, :notice => true, :error => true }
      levels.each_pair do |level, save|
        @mt = MyTask.new(level)
        @mt.log("some debugging text", :error)
        if save
          @mt.task_run.error_text.should match "some debugging text"
        else
          @mt.task_run.error_text.should_not match "some debugging text"
        end
      end
    end
  end
end
