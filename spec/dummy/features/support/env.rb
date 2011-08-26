require 'ruby-debug'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
#require 'trackable_tasks'

require 'cucumber/rails'
#require 'rspec/expectations'

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end
