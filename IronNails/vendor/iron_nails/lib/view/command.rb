module IronNails

  module View
  
    # Encapsulates commands that will be attached to the views.
    class Command
    
      include IronNails::Logging::ClassLogger
    
      # the name of the event that will trigger the action
      attr_accessor :trigger
      
      # the name of the element that will trigger the action
      attr_accessor :element
      
      # the action that will be triggered 
      attr_accessor :action
      
      # the view this command is bound to
      attr_accessor :view
      
      # the view model to which this command belongs
      attr_reader :view_model
      
      # indicates whether to execute this command on the ui thread or on a different thread.
      attr_accessor :mode
      
      # the name of the on which this command needs to be invoked
      attr_accessor :affinity
      
      # the name of this command
      attr_accessor :name
                        
      def initialize(options)
        raise ArgumentException.new("An element name is necesary") if options[:element].nil?
        raise ArgumentException.new("An action is necesary") if options[:action].nil?
        raise ArgumentException.new("A name is necesary") if options[:name].nil?
        
        @trigger = options[:event]||:click
        @element = options[:element]
        @action = options[:action]
        @view_model = options[:view_model]
        @mode = options[:mode]||:synchronous
        @affinity = options[:affinity]
        @name = options[:name]
        @changed = options[:changed]
      end 
      
      # flag to indicate whether this command needs a refresh in the view model
      def changed?
        !!@changed
      end
      
      def asynchronous?
        mode == :asynchronous
      end
      
      def refresh_view
        view_model.refresh_view
      end
      
      def attached?
        !@view.nil?
      end
      
      # executes this command (it calls the action)
      def execute
        log_on_error do
          action.call
          refresh_view unless asynchronous?
        end
      end
      
      def ==(command)
        self.name == command.name
      end
      
    end
  
  end

end