module IronNails

  module View
  
    class Command
    
      # the name of the event that will trigger the action
      attr_accessor :trigger
      
      # the name of the element that will trigger the action
      attr_accessor :element
      
      # the action that will be triggered 
      attr_accessor :action
      
      def initialize(options)
        raise ArgumentException.new("An element name is necesary") if options[:element].nil?
        raise ArgumentException.new("An action is necesary") if options[:action].nil?
        
        @trigger = options[:event]||:click
        @element = options[:element]
        @action = options[:action]
      end 
      
      # Attaches this command to the view 
      def attach_to(view)
        view.send(element.to_sym).send(trigger.to_sym) { execute }
      end
      
      # executes this command (it calls the action)
      def execute
        @action.call
      end
      
      class << self
        
        # Given a set of +command_definitions+ it will generate
        # a collection of Command objects for the view model
        def generate_for(command_definitions)
          commands = []
          command_definitions.each do |cmd_def|
            commands << new(cmd_def)
          end
          commands
        end 
        
      end
    
    end
  
  end

end