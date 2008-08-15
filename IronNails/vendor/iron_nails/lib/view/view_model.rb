require File.dirname(__FILE__) + "/command.rb"
module IronNails

  module View
    
    class ViewModel
      
      def initialize(name = '')
        super
      end
    end
    
    # The base class for view models in an IronNails application.
    module ViewModelMixin 
    
      include IronNails::Logging::ClassLogger
      
      # the view proxy that this view model is responsible for
      attr_accessor :view
      
      # gets or sets the commands to respond to user actions in the view.
      attr_accessor :commands
      
      # gets or sets the models that wil be used in the view to bind to
      attr_accessor :objects
      
       # flags the view model as in need of wiring up and 
       # sets the command collection
      def commands=(value)
        unless commands == value
          @configured = false 
          @commands = value
        end
      end
      
      # flags the view model as in need of wiring up and 
      # sets the model collection
      def objects=(value)
        unless objects == value
          @configured = false 
          @objects = value
        end
      end
      
      # loads a new instance of a view proxy into this model
      def set_view_name(name)
        @view_name = name
      end 
      
      def initialize(view_name='')
        @configured, @commands = false, CommandCollection.new
        set_view_name view_name unless view_name.empty?
      end
      
      # shows this view (probably a window)
      def show_view(reload=false)
        unless configured?
          if view.nil? || reload
            load_and_configure_view
          else
            configure_view
          end
        end
        view.show
      end
      
      # returns a configured instance of the view
      def get_view
        configure_view unless configured?
        view.instance
      end
      
      # returns whether this view needs configuration or not
      def configured?
        @configured
      end 
      
      # configures the properties for the view model
      def configure_properties
        objects.each do |o|
          o.each do |k, v|
            send "#{k}=".to_sym, v 
          end unless o.nil?
        end     
      end
      
      def add_command_to_view(cmd)
        view.add_command(cmd)        
      end
      
      # adds a command or a command collection to the queue
      def add_command_to_queue(cmd)
        if cmd.is_a? CommandCollection
          cmd.each do |c|
            if !commands.has_command?(c) || c.changed?
              commands << c 
              @configured = false
            end
          end
        elsif cmd.respond_to?(:execute) && cmd.respond_to?(:element) # define some sort of contract
          if !commands.has_command?(cmd) || cmd.changed?
            commands << cmd 
            @configured = false 
          end
        end
      end
      alias_method :add_commands_to_queue, :add_command_to_queue
      
      # attaches the commands to the view.
      def configure_events
        commands.each do |cmd|
          add_command_to_view cmd unless cmd.attached?
        end
      end
      
      # binds the view model to the view. It will setup the appropriate events, 
      # set the datacontext of the view so that all the data appears properly.s      
      def load_and_configure_view
        @view = Proxy.load(@view_name)
        configure_view
      end
      
      def configure_view
        configure_properties
        configure_events
        view.data_context = self
        @configured = true
      end
      
      def set_refresh_view(&refresh)
        @refresh_view = refresh
      end
      
      def refresh_view
        @refresh_view.call
        configure_properties
        configure_events
        @configured = true
      end
      
      def set_synchronise(&synchronise)
        @synchronise = synchronise
      end 
      
      def synchronise_viewmodel_with_controller
        @synchronise.call
      end 
             
    end
    
    class ViewModelBuilder
      
      # gets the view model instance to manipulate with this builder
      attr_reader :model
      
      # loads a new instance of the view into memory
      def set_view_name(name)
        model.set_view_name name
      end
      
      # gets the view proxy      
      def view
        model.view
      end
      
      def show_view
        model.show_view
      end 
      
      def add_command_to_view(cmd_def)
        model.add_commands_to_queue CommandCollection.generate_for(cmd_def, model)
      end
      
#      def view_instance
#        @model.view_instance
#      end

      def viewmodel_class
        @model.class
      end 
      
      def synchronise_viewmodel_with_controller
        model.synchronise_viewmodel_with_controller
      end 
      
      def synchronise_to_controller(controller)
        objects = controller.instance_variable_get "@objects"
        properties = model.to_clr_type.get_properties.collect { |pi| pi.name.to_s.to_sym }
        objects.each do |k,v|
          if properties.include? k.to_s.camelize.to_sym 
            val = model.send(k)
            objects[k] = val
            controller.instance_variable_set "@{k}", val
          end
        end
        
      end
      
      # builds a class with the specified +class_name+ and defines it if necessary. 
      # After it will load the proxy for the view with +view_name+
      def build_class_with(options)
        # FIXME: The line below will be more useful when we can bind to IronRuby objects
        # Object.const_set class_name, Class.new(ViewModel) unless Object.const_defined? class_name     

        # TODO: There is an issue with namespacing and CLR classes, they aren't registered as constants with
        #       IronRuby. This makes it hard to namespace viewmodels. If the namespace is included everything 
        #       should work as normally. Will revisit this later to properly fix it.        
        klass = Object.const_get options[:class_name]
        klass.include IronNails::View::ViewModelMixin
        @model = klass.new 
        model.set_refresh_view &options[:refresh]
        model.set_synchronise_viewmodel &options[:synchronise]
        set_view_name options[:view_name]      
          
        model
      end
      
      def initialize_with(command_definitions, objects)
        model.add_commands_to_queue CommandCollection.generate_for(command_definitions, model)
        model.objects = ModelCollection.generate_for(objects)
      end
      
      class << self
      
        # initializes a new view model class for the controller 
        def for_view_model(options)
          builder = new
          builder.build_class_with options
          builder
        end       
          
      end
      
    end
      
  end
  
end