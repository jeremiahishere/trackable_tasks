require 'rails'

require 'trackable_tasks/config'

module TrackableTasks
  class Railtie < ::Rails::Railtie
    initializer 'trackable_tasks' do |app|
      # add mixins here
    end
  end
end
