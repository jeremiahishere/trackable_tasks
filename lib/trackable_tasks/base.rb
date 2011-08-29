module TrackableTasks
  # Abstract trackable task to be overriden when creating a trackable task.
  #
  # Usage:
  #
  # Create a class
  # MyGenericTask < TrackableTasks:Base
  #
  # Override the run method
  # def run
  #   puts "Running my own code"
  # end
  #
  # Instantiate and call run_task
  #
  # my_generic_task = MyGenericTask.new
  # my_generic_task.run_task
  #
  # Bask in the glory of your saved logging information
  #
  # puts TrackableTasks.TaskRun.last.log_text
  class Base

    # Initializes the task run and sets the start time
    def initialize
      @task_run = TrackableTasks::TaskRun.create(:start_time => Time.now, :task_type => self.class.name, :success => true)
    end
    
    # this calls task with error catching
    # if an error is caught, sets success to false and records the error
    # either way, sets an end time and saves the task run information
    def run_task
      begin
        run 
      rescue Exception => e
        @task_run.add_error_text(e.class.name + ": " + e.message)
        @task_run.success = false
      end 
      @task_run.end_time = Time.now
      @task_run.save
    end
    
    # The run method must be overridden for the task to work
    # code for the actual task goes here
    def run
      raise NotImplementedError.new("The run method must be overridden")
    end

    # Adds test to the log for the task run
    #
    # @param [String] text The text to add to the log
    def log(text)
      @task_run.add_log_text(text)
    end
  end
end
