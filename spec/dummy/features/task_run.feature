Feature: task_run controller index and show pages 

	Scenario: should show task runs on the index page
	  Given a task_run exists
	  When I go to the task_run index page
	  Then I should see the data for that task_run
	
	Scenario: no task runs
	  Given a task_run does not exist
	  When I go to the task_run index page
	  Then I should see "There are no records"
	
	Scenario: no end time
	  Given a task_run exists
	  And end_time does not exist
	  When I go to the task_run index page
	  Then I should see "Run time not completed" in the run_time column
	
	Scenario: success is true
	  Given a task_run exists with the following values
	    | key | value |
	    | start_time | 11/2/2011 |
	    | task_type | Task type 2 |
	    | success | true |	  
	  When I go to the task_run index page
	  Then I should see the success color as green
	
	Scenario: should show task run on the show page
	  Given a task_run exists
	  When I go to the task_run show page
	  Then I should see the show data for that task_run
