require File.dirname(__FILE__) + "/collections"
require File.dirname(__FILE__) + "/view_model"
require File.dirname(__FILE__) + "/view_proxy"
module IronNails
  
  module View
  
    module ViewOperations
    
      # the view proxy that this view model is responsible for
      attr_accessor :view
      
      # loads a new instance of a view proxy into this model
      def set_view_name(name)
        @view_name = name
      end 
      
      # shows this view (probably a window)
      def show_view(reload=false)
        configure_view_for_showing
        view.show
      end
      
      # returns a configured instance of the view
      def get_view
        configure_view unless configured?
        view.instance
      end
      
      # gets the view model instance to manipulate with this builder
      attr_reader :model
       
      # gets or sets the command_queue to respond to user actions in the view.
      attr_accessor :command_queue
       
      # gets or sets the models that wil be used in the view to bind to
      attr_accessor :model_queue
       
      # flags the view model as in need of wiring up and 
      # sets the command collection
      def command_queue=(value)
        unless command_queue == value
          @configured = false 
          @command_queue = value
        end
      end
       
      # flags the view model as in need of wiring up and 
      # sets the model collection
      def model_queue=(value)
        unless model_queue == value
          @configured = false 
          @model_queue = value
        end
      end
      
      def configure_view_for_showing
        unless configured?
          if view.nil? || reload
            load_and_configure_view
          else
            configure_view
          end
        end
      end
      
      # binds the view model to the view. It will setup the appropriate events, 
      # set the datacontext of the view so that all the data appears properly.s      
      def load_and_configure_view
        @view = ViewProxy.load(@view_name)
        configure_view
      end
      
      # configures the view 
      def configure_view
        raise IronNails::Errors::ContractError.new :configure_view
      end
      
      def refresh_view
        raise IronNails::Errors::ContractError.new :refresh_view
      end
      
    end
    
    module ViewModelOperations
    
      # gets the view model instance to manipulate with this builder
      attr_reader :model
      
      # gets or sets the command_queue to respond to user actions in the view.
      attr_accessor :command_queue
      
      # gets or sets the models that wil be used in the view to bind to
      attr_accessor :model_queue
      
      # flags the view model as in need of wiring up and 
      # sets the command collection
      def command_queue=(value)
        unless command_queue == value
          @configured = false 
          @command_queue = value
        end
      end
      
      # flags the view model as in need of wiring up and 
      # sets the model collection
      def model_queue=(value)
        unless model_queue == value
          @configured = false 
          @model_queue = value
        end
      end
      
      def add_model_to_queue(model)
        if model.respond_to?(:has_model?)
          model.each do |m|
            enqueue_model(m)                       
          end 
        elsif model.is_a?(Hash)
          enqueue_model(model)
        end
      end
      alias_method :add_models_to_queue, :add_model_to_queue
      
      
      # adds a command or a command collection to the queue
      def add_command_to_queue(cmd)
        if cmd.respond_to?(:has_command?)
          cmd.each do |c|
            enqueue_command(c)
          end
        elsif cmd.respond_to?(:execute) && cmd.respond_to?(:refresh_view) # define some sort of contract
          enqueue_command(cmd)
        end
      end
      alias_method :add_commands_to_queue, :add_command_to_queue
      
      
      
      
      
      private 
        
        def enqueue_command(cmd)
          if !command_queue.has_command?(cmd) || cmd.changed?
            command_queue << cmd 
            @configured = false 
          end
        end
        
        def enqueue_model(model)
          key = model.keys[0]
          unless model_queue.has_model?(model) && model_queue[key] == model[key]
            model_queue.add_model model
            @configured = false
          end
        end   
      
    end
    
    class ViewPresenter
      
      include IronNails::Logging::ClassLogger
      include IronNails::Core::Observable
      extend Forwardable
      include IronNails::View::ViewOperations
      include IronNails::View::ViewModelOperations
      
      
      def_delegator :@model, :class, :viewmodel_class
       
      # configures the properties for the view model
      def configure_models
        model_queue.each do |o|
          o.each do |k, v|
            model.add_model k, v
          end unless o.nil?
        end     
      end
      
      # processes the command queue.
      def configure_events
        command_queue.each do |cmd|
          model.add_command_to_view cmd unless cmd.attached?
        end
      end
       
      # configures the view
      def configure_view
        configure_models
        configure_events
        view.data_context = model
        @configured = true
      end       
              
      # refreshes the data for the view.
      def refresh_view
        notify_observers :refreshing_view, self
        configure_models
        configure_events
        @configured = true
      end
       
      # synchronises the data in the viewmodel with the controller
      def synchronise_with_controller
        notify_observers :reading_input, self
      end 
      
      def add_command_to_view(cmd_def)
        norm = normalize_command_definitions(cmd_def)
        add_commands_to_queue CommandCollection.generate_for(norm, self)
      end

      def synchronise_to_controller(controller)
        objects = controller.instance_variable_get "@objects"
        properties = model.objects.collect { |kvp| kvp.key.to_s.underscore.to_sym }
        objects.each do |k,v|
          if model.objects.contains_key(k.to_s.camelize)
            val = model.objects.get_value(k.to_s.camelize).value
            objects[k] = val
            controller.instance_variable_set "@{k}", val
          end
        end
        
      end
      
      # returns whether this view needs configuration or not
      def configured?
        !!@configured
      end
      
      # Generates the command definitions for our view model.
      def normalize_command_definitions(definitions, controller)
        command_definitions = {}
        
        definitions.each do |k, v|
          command_definitions[k] = normalize_command_definition(k, v, controller)
        end unless definitions.nil?
        
        command_definitions        
      end 
      
      # Generates a command definition for our view model.
      # When it can't find a key :action in the options hash for the view_action
      # it will default to using the name as the command as the connected option.
      # It will generate a series of commands for items that have more than one trigger      
      def normalize_command_definition(name, options, controller)
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
      
      # builds a class with the specified +class_name+ and defines it if necessary. 
      # After it will load the proxy for the view with +view_name+
      def build_class_with(options)
        # FIXME: The line below will be more useful when we can bind to IronRuby objects
        # Object.const_set options[:class_name], Class.new(ViewModel) unless Object.const_defined? options[:class_name]     
        
        # TODO: There is an issue with namespacing and CLR classes, they aren't registered as constants with
        #       IronRuby. This makes it hard to namespace viewmodels. If the namespace is included everything 
        #       should work as normally. Will revisit this later to properly fix it.        
        klass = Object.const_get options[:model]
        klass.include IronNails::View::ViewModelMixin
        @model = klass.new 
        @configured, @command_queue, @model_queue = false, CommandCollection.new, ModelCollection.new
        set_view_name options[:view]      
        puts "created a viewmodel: #{model.class}"
        model
      end
      
      def initialize_with(command_definitions, models, controller)
        definitions = normalize_command_definitions command_definitions, controller
        add_commands_to_queue CommandCollection.generate_for(definitions, self)
        add_models_to_queue ModelCollection.generate_for(models)
        puts "Added commands to queue on presenter for #{@view_name}."
        puts "Added models to queue on presenter for #@view_name"
      end
      
      class << self
        
        # initializes a new view model class for the controller 
        def for(options)
          presenter = new
          presenter.build_class_with options
          presenter
        end       
        
      end
      
    end
    
  end
  
end