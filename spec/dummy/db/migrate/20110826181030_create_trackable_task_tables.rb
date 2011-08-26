class CreateTrackableTaskTables < ActiveRecord::Migration
  def self.up
    create_table :trackable_tasks_task_runs do |t|
      t.string :task_type
      t.datetime :start_time
      t.datetime :end_time
      t.text :error_text
      t.text :log_text
      t.boolean :success
    end 
  end

  def self.down
    drop_table :task_runs
  end
end
