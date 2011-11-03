Given /^a task_run does not exist$/ do
  TrackableTasks::TaskRun.nil?
end

Then (/^I should see "([^"]*)" $/) do |no_reconds|
  task_run = TrackableTasks::TaskRun.last
  page.should have_content(no_records)
end

Given /^a task_run exists$/ do
  TrackableTasks::TaskRun.create(:start_time => Time.now, :task_type => 'Test Task', :success => true, :error_text => "This is an error", :log_text => "This is a log")
end

Given /^a task_run exists with the following values$/ do |table|
  attributes = {}  
  table.hashes.each do |key_pair|   
    if !key_pair["key"] == 'key'
      attributes[key_pair["key"]] = key_pair["value"]
    end   
  end
  TrackableTasks::TaskRun.create(attributes)  
end

Then /^I should see the data for that task_run$/ do
  task_run = TrackableTasks::TaskRun.last 
  page.should have_content(task_run.start_time.strftime('%D'))
  page.should have_content(task_run.task_type)
  page.should have_content(task_run.success)
end

Then (/^I should see "([^"]*)" in the run_time column$/) do |run_time_message|
  task_run = TrackableTasks::TaskRun.last
  task_run.run_time == run_time_message
end

Then /^I should see the show data for that task_run$/ do
  task_run = TrackableTasks::TaskRun.last
  page.should have_content(task_run.start_time.strftime('%D'))
  page.should have_content(task_run.task_type)
  page.should have_content(task_run.success)
  page.should have_content(task_run.log_text)
  page.should have_content(task_run.error_text)
end

Given /^success is true$/ do
  task_run = TrackableTasks::TaskRun.last
  task_run.success == true
end

Given /^there is no error_text$/ do
  task_run = TrackableTasks::TaskRun.last
  task_run.error_text.nil?
end

Then /^I should see the success color as green$/ do
  task_run = TrackableTasks::TaskRun.last
  page.should have_content("color: green")
end

