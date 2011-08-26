module TrackableTasks
  class Base
    # Initializes the class and calls the run method
    def initialize
      @task_run = TrackableTasks::TaskRun.create(:start_time => Time.now, :task_type => self.class.name, :success => true)
    end
    
    # this calls task with error catching
    def run_task
      begin
        run 
      rescue error
        @task_run.error_text = error.message
        @task_run.success = false
      end 
      @task_run.end_time = Time.now
      @task_run.save
    end
    
    # The actual task should go here
    def run
      raise NotImplementedError.new("The run method must be overridden")
    end

    def log(text)
      @task_run.add_log_text(text)
    end
    
  end
end
