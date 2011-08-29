require 'spec_helper'

describe TrackableTasks::Base do
  describe "initialize method" do
    before(:each) do 
      @mt = MyTask.new
      @task_run = TrackableTasks::TaskRun.last
    end

    it "should create a task run instance" do
      TrackableTasks::TaskRun.all.length.should == 1
    end

    it "should set the start time" do
      @task_run.start_time.should_not be_nil
    end

    it "should set the type" do
      @task_run.task_type.should == "MyTask"
    end
    
    it "should be successful" do
      # it should be successful on initialization
      @task_run.success.should be_true
    end
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
      @task_run = TrackableTasks::TaskRun.last
      @task_run.success.should be_true
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
      @mt.method(:log).arity.should == 1
    end

    it "should call the task run's add_log_text method" do
      @mt.log("test log text")
      #note that we have to call run_task here becuase there is not explicit way to save mt.task_run
      @mt.run_task
      @task_run = TrackableTasks::TaskRun.last
      @task_run.log_text.should match "test log text"
    end
  end
end