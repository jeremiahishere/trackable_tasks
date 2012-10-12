class DebugTask < TrackableTasks::Base
  
  # test of the tracking and logging systems
  def run
    log("Debug level log", :debug)
  end
end
