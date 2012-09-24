class MyTask < TrackableTasks::Base
  
  # test of the tracking and logging systems
  def run
    log("Error level log", :error)
    log("Notice level log", :notice)
    log("Debug level log", :debug)
  end
end
