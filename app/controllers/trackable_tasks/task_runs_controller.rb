# Index and show controller for TaskRuns 
# TaskRuns should not be created or edited here because they are generate by rake tasks 
class TrackableTasks::TaskRunsController < ApplicationController
  # Lists all tasks in task run 
  def index    
    @task_runs = TrackableTasks::TaskRun.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # Lists specific task run 
  def show
    @task_run = TrackableTasks::TaskRun.find_by_id(params[:id])
    
    
    respond_to do |format|
      format.html # show.html.erb
    end
    
  end
end
  