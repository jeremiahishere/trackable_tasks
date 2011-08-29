class MyTask < TrackableTasks::Base
  
  def initialize
    #puts "Initializing"
    super
  end

  def run
    #log "Running MyTask"
  end
end

class ErroringTask < TrackableTasks::Base

  def error_text
    "This task is supposed to error so here it is."
  end

  def run
    raise error_text
  end
end

class TaskWithoutRun < TrackableTasks::Base
end
