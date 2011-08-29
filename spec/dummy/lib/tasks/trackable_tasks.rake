#require 'ruby-debug'
# call with 'rake trackable_task:my_task log_level=debug' or 'rake trackable_task:my_task[:debug]'
namespace :trackable_task do

  # this part isn't working
  trackable_task_list = []
  Directory.foreach do |file_name|
    next if file_name == "." || file_name == ".."
    file_name['.rb'] = ''
    trackable_task_list.push(file_name.to_sym)
  end

  # this is the temporary fix
  trackable_task_list = [:my_task, :some_other_task]

  trackable_task_list.each do |task_name|
    task task_name, :log_level do |t, args|
      args = ENV["log_level"] ? { :log_level => ENV["log_level"] } : args.with_defaults(:log_level => :notice)
      puts "I am running #{task_name.to_s} task and args #{args}"
    end
  end
end
