include Rake::DSL

# Careful when editing this file.  It may be overwritten when the gem is updated.
namespace :trackable_task do

  # loads the trackable tasks from /lib/trackable_tasks
  # this may be moved to a config file at some point
  trackable_task_list = []
  Dir.foreach("#{::Rails.root.to_s}/lib/trackable_tasks/") do |file_name|
    next if file_name == "." || file_name == ".."
    file_name['.rb'] = ''
    trackable_task_list.push(file_name.to_sym)
  end

  # turns the array of trackable tasks into individual rake tasks
  trackable_task_list.each do |task_name|
    desc "Trackable task for #{task_name.to_s.camelize}.  Optionally set the log_level ENV variable to debug, notice, and error."
    task task_name => :environment do |t|
      log_level = ENV["log_level"]
      run_trackable_task(task_name.to_s, log_level)
    end
  end

  # single rake task that can run any trackable task
  desc "Runs a trackable task by passing in the task as an argument"
  task :run => :environment do |t|
    task_name = ENV["task_name"]
    log_level = ENV["log_level"]
    run_trackable_task(task_name, log_level)
  end

  # Runs the trackable task by constantizing the task name, initializing, and calling run task
  #
  # @param [String] The name of the task class
  # @param [String] The log level for the task
  def run_trackable_task(task_name, log_level)
    require "#{::Rails.root.to_s}/lib/trackable_tasks/#{task_name}.rb"
    # if the class exists
    trackable_task = task_name.camelize.constantize.new(log_level)
    # if the class has a superclass of trackable task base
    if trackable_task.class.superclass == TrackableTasks::Base
      trackable_task.run_task
    else
      puts "The task #{task_name} was not an instance of TrackableTasks::Base."
    end
  end
end
