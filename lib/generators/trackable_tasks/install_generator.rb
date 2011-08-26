require 'rails/generators'
require 'rails/generators/migration'
require 'active_record'
require 'rails/generators/active_record'

module TrackableTasks 
  module Generators
    # Generator for copying the base migration and the rakefile to the including project
    #
    # @author Jeremiah Hemphill
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc <<DESC
Description:
  Copies over migrations and rakefile for the trackable tasks system.
DESC
      # Implement the required interface for Rails::Generators::Migration.
      # thanks Kaminari gem for this bit of code
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end

      # Creates the rake file
      def copy_rake_file
        copy_file "trackable_tasks.rake", "lib/tasks/trackable_tasks.rake"
      end

      # Creates the migration
      def copy_migration
        migration_template "migrations/install_migration.rb.erb", "db/migrate/create_trackable_task_tables.rb"
      end
    end
  end
end

