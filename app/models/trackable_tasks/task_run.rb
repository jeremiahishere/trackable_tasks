module TrackableTasks
  # Stores information about a single execution of a trackable task
  # Records errors and logs, and gives information about how long the execution took
  class TaskRun < ActiveRecord::Base
    set_table_name "trackable_tasks_task_runs"

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
  end
end
