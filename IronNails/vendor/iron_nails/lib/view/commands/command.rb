module IronNails
  
  module View
    
    # The base class for view commands in IronNails.
    class Command
      
      include IronNails::Logging::ClassLogger            
      
      # the view this command is bound to
      attr_accessor :view
      
      # the view model to which this command belongs
      attr_reader :view_model
      
      # indicates whether to execute this command on the ui thread or on a different thread.
      attr_accessor :mode
      
      # the name of this command
      attr_accessor :name
      
      # the action that will be triggered 
      attr_accessor :action
      
      # the predicate that decides whether this command can execute or not
      attr_accessor :condition
      
      def initialize(options)
        read_options options
      end 
      
      def read_options(options)
        raise ArgumentError.new("A name is necesary") if options[:name].nil?
        raise ArgumentError.new("An action is necesary") if options[:action].nil?
        
        @action = options[:action]        
        @view_model = options[:view_model]
        @mode = options[:mode]||:synchronous
        @name = options[:name]
        @condition = options[:condition]
        @changed = options[:changed]                
      end
      
      # flag to indicate whether this command needs a refresh in the view model
      def changed?
        !!@changed
      end
      
      def can_execute?
        !!(condition.nil?||condition.call)
      end
      
      def asynchronous?
        mode == :asynchronous
      end
      
      def refresh_view
        view_model.refresh_view
      end
      
      def synchronise_viewmodel_with_controller
        view_model.synchronise_viewmodel_with_controller
      end
      
      def attached?
        !view.nil?
      end
      
      # executes this command (it calls the action)
      def execute
        #log_on_error do
          #synchronise_viewmodel_with_controller
          action.call
          refresh_view unless asynchronous?
        #end if can_execute?
      end
      
      def ==(command)
        self.name == command.name
      end
      alias_method :===, :==
      alias_method :equals, :==
      
      def <=>(command)
        self.name <=> command.name
      end
      alias_method :compare_to, :<=>
      
      class << self
        
        def create_from(definition)
          mapping = {
            :event => EventCommand,
            :timed => TimedCommand,
            :behavior => BehaviorCommand
          }
          
          mapping[definition[:type]||:behavior].new definition
        end
        
      end
      
    end
    
  end
  
end