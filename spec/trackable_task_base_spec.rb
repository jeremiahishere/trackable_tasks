require 'spec_helper'

describe TrackableTasks::Base do
  it "should do things" do
    mt = MyTask.new()
  end

  describe "initialize method" do
    it "should create a task run instance"
    it "should set the start time"
    it "should set the type"
  end

  describe "run_task" do
    it "should call the run method"
    it "should handle errors from the run method by saving them to the error log"
    it "should set the task run's success field to true if no errors have been added"
  end

  describe "run method" do
    it "should error if it isn't overriden"
  end

  describe "log method" do
    it "should take one argument"
    it "should call the task run's add_log_text method"
  end
end
