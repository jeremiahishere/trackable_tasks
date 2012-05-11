module TrackableTasks
  # Stores information about a single execution of a trackable task
  # Records errors and logs, and gives information about how long the execution took
  class TaskRun < ActiveRecord::Base
    set_table_name "trackable_tasks_task_runs"

    attr_accessible :start_time, :end_time, :task_type, :success

    validates_presence_of :start_time, :task_type
    validates_inclusion_of :success, :in => [true, false]
    validate :end_time_after_start_time

    # adds an error if the end time is after the start time
    # does not add an error if the end time is not set
    def end_time_after_start_time
      if self.end_time && self.end_time < self.start_time
        self.errors.add(:end_time, "The end time must be after the start time")
      end
    end

    scope :newest_first, lambda { order("trackable_tasks_task_runs.start_time desc") }
    scope :today, lambda { where(["trackable_tasks_task_runs.start_time >= ?", 24.hours.ago]) }
    # this may have some odd effects on things that are 7 days but less than 7 * 24 hours old
    scope :this_week, lambda { where(["trackable_tasks_task_runs.start_time >= ?", 7.days.ago]) }

    # Restrict task runs by a time period of today, this week or all time
    #
    # @param String timeframe Which tasks to look for, 'all', 'week', or 'today'
    def self.by_timeframe(timeframe = "")
      if timeframe =='week'
        this_week
      elsif timeframe == 'all'
        all 
      else
        today
      end
    end

    # @param time_period String Whether to search for today's tasks or this week's tasks
    # @return Hash Percentage of tasks that succeeded today organized by task name
    def self.percentages_by_task_type(timeframe = "")
      task_runs = by_timeframe(timeframe)
      task_types = task_runs.collect { |tr| tr.task_type }.uniq

      percentages = []
      task_types.each do |task_type|
        runs = task_runs.where(:task_type => task_type).count
        percentages << {
          :name => task_type,
          :runs => runs,
          :percentage => 100 * task_runs.where(:task_type => task_type, :success => true).count / runs,
        }
      end
      return percentages.sort { |p| p[:percentage] }
    end

    # Appends the input text onto the log text
    #
    # I am aware that these two methods are duplicates nd we could merge them
    # I am not convinced that the code would be any more readable or maintainable
    # It does cut down the number of tests though
    #
    # @param [String] text The text to append to the log text
    def add_log_text(text)
      self.log_text = "" if self.log_text.nil?
      self.log_text += text + "\n"
    end

    # Appends the input text onto the error text
    #
    # @param [String] text The text to append to the error text
    def add_error_text(text)
      self.error_text = "" if self.error_text.nil?
      self.error_text += text + "\n"
    end
    
    # Creates run time based on start and end time
    # If there is no end_time, display 'Run has not completed.'  
    # @return [String] The run time formatted in hours, minutes and seconds
    # @return [String] Message that run has not completed 
    def display_run_time
      if self.end_time         
         return run_time_or_time_elapsed.gmtime.strftime('%R:%S')
      else
         return "Run has not completed."
      end
    end 

    # Creates run time based on start and end time
    # If there is no end_time, returns time between start and now
    # @return [Time] The run time object
    def run_time_or_time_elapsed
      if self.end_time         
         return Time.at(self.end_time - self.start_time)
      else
         return Time.at(Time.now - self.start_time)
      end
    end
    
    # Determines error message color based on success and whether or not there is error text  
    # Return value corresponds to a css color 
    # @return [String] The color of the status/error message
    def status_color
      if self.success && self.error_text.nil?
        return 'green'
      elsif self.success
        return 'yellow'
      else
        return 'red'
      end
    end       
  end
end
