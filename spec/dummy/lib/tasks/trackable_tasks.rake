include Rake::DSL
#require 'ruby-debug'
# call with 'rake trackable_task:my_task log_level=debug' or 'rake trackable_task:my_task[:debug]'
namespace :trackable_task do

  trackable_task_list = []
  Dir.foreach("#{RAILS_ROOT}/lib/trackable_tasks/") do |file_name|
    next if file_name == "." || file_name == ".."
    file_name['.rb'] = ''
    trackable_task_list.push(file_name.to_sym)
  end

  trackable_task_list.each do |task_name|
    desc "Trackable task for #{task_name.to_s.camelize}.  Log levels include debug, notice, and error."
    task task_name, :log_level do |t, args|
      args = ENV["log_level"] ? { :log_level => ENV["log_level"] } : args.with_defaults(:log_level => :notice)
      run_trackable_task(task_name.to_s, args[:log_level])
    end
  end

  desc "Runs a trackable task by passing in the task as an argument"
  task :run, :task_name, :log_level do |t, args|
    args[:log_level] = args.with_defaults(:log_level => :notice)
    run_trackable_task(args[:task_name], args[:log_level])
  end

  def run_trackable_task(task_name, log_level)
    puts "I am running #{task_name} at log level #{log_level}"
    # if the class exists
    task = task_name.camelize.constantize.new(log_level)
    # if the class has a superclass of trackable task base
    if task.superclass == "TrackableTasks:Base"
      task.run_task
    end
  end
end
