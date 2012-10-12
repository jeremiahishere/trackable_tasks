class NoticeTask < TrackableTasks::Base
  
  # test of the tracking and logging systems
  def run
    log("Notice level log", :notice)
  end
end
