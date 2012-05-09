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
	    | start_time | 2011-11-03 16:31:19 -0400 |
	    | task_type | Task type 3 |
	    | success | true |	  
	  When I go to the task_run index page
    And I follow "All Time"
	  Then status_color should be green
	
	Scenario: should show task run on the show page
	  Given a task_run exists with the following values
	    | key | value |
	    | start_time | 2011-11-03 16:31:19 -0400 |
	    | end_time | 2011-11-03 17:53:40 -0400  |
	    | task_type | Task type 4 |
	    | success | true |
	    | error_text | This is some error text |
	    | log_text | This is some log text |
	  When I go to the task_run show page
	  Then I should see the show data for that task_run
