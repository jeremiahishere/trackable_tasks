module TrackableTasks
  class Base
    # Initializes the class and calls the run method
    def initialize
    end
    
    # The actual task should go here
    def run
      raise NotImplementedError.new("The run method must be overridden")
    end

    def log
    end
    
  end
end
