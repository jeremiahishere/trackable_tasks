# Index and show controller for TaskRuns 
# TaskRuns should not be created or edited here because they are generate by rake tasks 
class TaskRunsController < ApplicationController
  # Lists all tasks in task run 
  def index    
    @taskruns = TrackableTasks::TaskRun.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # Lists specific task run 
  def show
    @taskrun = TrackableTasks::TaskRun.find_by_id(params[:id])
    
    
    respond_to do |format|
      format.html # show.html.erb
    end
    
  end
end
  