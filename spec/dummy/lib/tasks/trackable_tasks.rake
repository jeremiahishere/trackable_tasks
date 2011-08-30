include Rake::DSL
require 'ruby-debug'
# call with 'rake trackable_task:my_task log_level=debug' or 'rake trackable_task:my_task[:debug]'
namespace :trackable_task do

  trackable_task_list = []
  Dir.foreach("#{::Rails.root.to_s}/lib/trackable_tasks/") do |file_name|
    next if file_name == "." || file_name == ".."
    file_name['.rb'] = ''
    trackable_task_list.push(file_name.to_sym)
  end

  trackable_task_list.each do |task_name|
    desc "Trackable task for #{task_name.to_s.camelize}.  Optionally set the log_level ENV variable to debug, notice, and error."
    task task_name => :environment do |t|
      log_level = ENV["log_level"]
      run_trackable_task(task_name.to_s, log_level)
    end
  end

  desc "Runs a trackable task by passing in the task as an argument"
  task :run => :environment do |t|
    task_name = ENV["task_name"]
    log_level = ENV["log_level"]
    run_trackable_task(task_name, log_level)
  end

  def run_trackable_task(task_name, log_level)
    #puts "I am running #{task_name} at log level #{log_level}"
    require "#{::Rails.root.to_s}/lib/trackable_tasks/#{task_name}.rb"
    # if the class exists
    task = task_name.camelize.constantize.new(log_level)
    # if the class has a superclass of trackable task base
    if task.class.superclass == TrackableTasks::Base
      task.run_task
    else
      puts "The task #{task_name} was not an instance of TrackableTasks::Base."
    end
  end
end
