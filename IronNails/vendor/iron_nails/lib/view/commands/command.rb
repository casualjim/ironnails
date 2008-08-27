module IronNails
  
  module View
    
    # The base class for view commands in IronNails.
    class Command
      
      include IronNails::Logging::ClassLogger      
      include IronNails::Core::Observable      
      
      # the view this command is bound to
      attr_accessor :view
            
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
        notify_observers :refreshing_view, self
      end
      
      def synchronise_viewmodel_with_controller
        notify_observers :reading_input, self
      end
      
      def attached?
        !view.nil?
      end
      
      # executes this command (it calls the action)
      def execute
        #log_on_error do
          synchronise_viewmodel_with_controller
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
            
    end
    
    class CommandBuilder
      
      attr_accessor :controller
      
      attr_accessor :command_mapping
      
      
      def initialize(controller)
        @controller = controller
        @command_mapping= {
                            :event => EventCommand,
                            :timed => TimedCommand,
                            :behavior => BehaviorCommand
                          }
      end
      
      # Given a set of +command_definitions+ it will generate
      # a collection of Command objects for the view model
      def generate_for(cmd_def)
        norm = normalize_command_definitions(cmd_def)
        cmds = generate_command_collection_from_normalized_definitions norm
        cmds
      end
      
      def view_model
        WpfApplication.current.view_manager
      end
            
      # Generates the command definitions for our view model.
      def normalize_command_definitions(definitions)
        command_definitions = {}
        
        definitions.each do |k, v|
          command_definitions[k] = normalize_command_definition(k, v)
        end unless definitions.nil?
        
        command_definitions        
      end 
      
      # Generates a command definition for our view model.
      # When it can't find a key :action in the options hash for the view_action
      # it will default to using the name as the command as the connected option.
      # It will generate a series of commands for items that have more than one trigger      
      def normalize_command_definition(name, options)
        mode = options[:mode]
        act = options[:action]||name
        action = act
        action = controller.method(act) if act.is_a?(Symbol) || act.is_a?(String)
        
        if options.has_key?(:triggers) && !options[:triggers].nil?
          triggers = options[:triggers]
          
          cmd_def = 
          if  triggers.is_a?(String) || triggers.is_a?(Symbol)
            { 
              :element => triggers, 
              :event   => :click, 
              :action  => action,
              :mode    => mode,
              :type    => :event
            } 
          elsif triggers.is_a?(Hash)          
            triggers.merge({:action => action, :mode => mode, :type => :event }) 
          elsif triggers.is_a?(Array)
            defs = []
            triggers.each do |trig|
              trig = { :element => trig, :event => :click } unless trig.is_a? Hash
              trig[:event] = :click unless trig.has_key? :event
              defs << trig.merge({ :action => action, :mode => mode, :type => :event })
            end 
            defs
          end
          cmd_def
        else
          exec = options[:execute]
          execute = exec
          execute = controller.method(exec) if exec.is_a?(Symbol) || exec.is_a?(String)
          controller_action, controller_condition = execute || action, options[:condition]
          {
            :action => controller_action,
            :condition => controller_condition,
            :mode => mode,
            :type => :behavior
          }
        end 
      end
      
      def generate_command_collection_from_normalized_definitions(definitions)
        commands = CommandCollection.new
        definitions.each do |name, cmd_def|
          cmd = create_command_from(cmd_def.merge({ :view_model => view_model, :name => name }))
          commands << cmd
        end if definitions.is_a?(Hash)
        commands
      end 
      
      def create_command_from(definition)
        command_mapping[definition[:type]||:behavior].new definition
      end
      
    end
    
  end
  
end