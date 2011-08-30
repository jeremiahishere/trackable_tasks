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
      puts "I am running #{task_name.to_s} task and args #{args}"
      # if the class exists
        # if the class has a superclass of trackable task base
          # initialize
          # run task
    end
  end
end
