require 'ruby-debug'

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
    #
    # @param [Symbol] log_level The log level for the task, defaults to notice
    def initialize(log_level = :notice)
      @task_run = TrackableTasks::TaskRun.create(:start_time => Time.now, :task_type => self.class.name, :success => true)

      @log_levels = [:debug, :notice, :error]
      @log_level = allowable_log_level(log_level)
    end

    # Checks if the log level is an allowable level, then returns it or notice if it is not allowable
    #
    # @param [Sybmol] log_level Log level to check
    # @return [Symbol] The given log level or notice if it is not allowable
    def allowable_log_level(log_level) 
      log_level = log_level.to_sym unless log_level.is_a?(Symbol)
      if !@log_levels.include?(log_level)
        log_level = :notice
      end
      return log_level
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
    # Depending on the @log_level, save or don't save the text
    # If the level is :error, save to the error log
    #
    # @param [String] text The text to add to the log
    # @param [Symbol] level The log level of the text
    def log(text, level = :notice)
      level = allowable_log_level(level)

      if level == :debug && @log_level == :debug
        @task_run.add_log_text(text)
      elsif level == :notice && (@log_level == :debug || @log_level == :notice)
        @task_run.add_log_text(text)
      elsif level == :error
        @task_run.add_error_text(text)
      end
    end
  end
end
