require "spec_helper"
require "rake"

# only doing light testing of the rake tasks
# probably could increase coverage at some point but I can't figure out how to stub the run_trackable_task function
describe "trackable_task rake tasks" do
  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "dummy/lib/tasks/trackable_tasks"
    Rake::Task.define_task(:environment)
  end

  describe "dynamic rake task" do
    it "should load the file names in the lib/trackable_tasks folder" do
      @task_name = "trackable_task:my_task"
      @rake[@task_name].invoke
      TrackableTasks::TaskRun.last.task_type.should == "MyTask"
    end
  end

  describe "run rake task" do
    before(:each) do
      @task_name = "trackable_task:run task_name=my_task"
      @rake[@task_name].invoke
      TrackableTasks::TaskRun.last.task_type.should == "MyTask"
    end
  end
end
