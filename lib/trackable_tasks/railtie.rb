require 'rails'
require 'trackable_tasks/config'
require 'rake'

module TrackableTasks
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/trackable_tasks.rake', __FILE__)
    end
  end
end
