class MyTask < TrackableTasks::Base
  
  # test of the tracking and logging systems
  def run
    sleep(5+rand(120))
    log("Error level log", :error)
    log("Notice level log", :notice)
    log("Debug level log", :debug)
  end
end
