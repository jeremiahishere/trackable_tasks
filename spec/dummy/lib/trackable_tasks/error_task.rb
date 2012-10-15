class ErrorTask < TrackableTasks::Base
  
  # test of the tracking and logging systems
  def run
    log("Error level log", :error)
  end
end
