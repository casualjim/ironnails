require File.dirname(__FILE__) + "/view/collections"
require File.dirname(__FILE__) + "/view/view_model"
require File.dirname(__FILE__) + "/view/xaml_proxy"
require File.dirname(__FILE__) + "/observable"

module IronNails
  
  module Core
    
    module ViewOperations
      
      def init_view_operations
      end
      
      def build_view(options)
        logger.debug "View to load: #{options[:name]}", IRONNAILS_FRAMEWORKNAME
        vw = IronNails::View::View.new(options)
        #vw.add_observer(:loaded) { |sender| set_data_context_for(sender) }
        vw
      end
      
      def register_child_view(options)
        vw = registry.view_for options[:controller]
        vw.add_child(options)
      end
      
      def register_view_for(controller)
        vw = build_view(:name => controller.view_name.to_sym, :controller => controller.controller_name)
        vw.add_observer(:configuring) { |sender| configure_view(sender) }
        registry.register_view_for controller, vw
      end
      
      def on_view(controller, name = nil, &b)
        find_view(controller, name).on_proxy(&b) #unless vw.nil?
      end
      
      def from_view(controller, name, target, method)
        find_view(controller, name).get_property(target, method)
      end
      
      def to_update_ui_after(controller, options, &b)
#        if options.is_a? Hash
#          klass = options[:class]||BindableCollection
#          request = options[:request]
#        else
#          klass = BindableCollection
#          request = options
#        end
#        cb = System::Threading::WaitCallback.new do
#          begin
#            registry.view_for(controller).dispatcher.begin_invoke(DispatcherPriority.normal, Action.of(klass).new(&b), request.call)
#          rescue WebException => e
#            MessageBox.Show("There was a problem logging in to Twitter. #{e.message}");
#          rescue RequestLimitException => e
#            MessageBox.Show(e.message)
#          rescue SecurityException => e
#            MessageBox.Show("Incorrect username or password. Please try again");
#          end
#        end
#        System::Threading::ThreadPool.queue_user_work_item cb  
        cb = nil
        cb = options[:callback] unless options[:callback].nil?
        options[:callback] = lambda do |vw|
          b.call 
          refresh_view(vw)
        end     
        find_view(controller, name).to_update_ui_after(options, &b)
      end 
      
      def on_ui_thread(controller, options=nil, &b)
        if options.is_a? Hash
          data = options[:data]
          klass = options[:class] || data.class
        else
          unless options.nil?
            klass = options.class    
            data = options
          end
        end
        b.call
        #registry.view_for(controller).dispatcher.begin_invoke(DispatcherPriority.normal, options.nil? ? Action.new(&b) : Action.of(klass).new(&b), data)
      end
      alias_method :on_ui_thread_with, :on_ui_thread
      
      def play_storyboard(controller, name, storyboard)
        logger.debug "finding controller #{controller.controller_name} and view #{name} to play #{storyboard}"
        vw = find_view(controller, name)
        find_view(controller, name).play_storyboard(storyboard)
      end 
      
      def stop_storyboard(controller, view_name, storyboard)
        find_view(controller, name).stop_storyboard(storyboard)
      end
      
      def find_view(controller, name)
        registry.view_for(controller).find(name)
      end
    end
    
    module ViewModelObjectOperations
      
      # gets or sets the models that wil be used in the view to bind to
      attr_accessor :model_queue
      
      def init_object_operations
        @model_queue = ModelCollection.new
      end
      
      # flags the view model as in need of wiring up and 
      # sets the model collection
      def model_queue=(value)
        unless model_queue == value
          @configured = false 
          @model_queue = value
        end
      end
      
      # adds a new model to the queue for synchronisation to the view
      def add_model_to_queue_on(model)
        if model.respond_to?(:has_model?)
          model.each do |m|
            enqueue_model(m)                       
          end 
        elsif model.is_a?(Hash)
          enqueue_model(model)
        end
      end
      alias_method :add_models_to_queue_on, :add_model_to_queue_on
      
      private 
      
      def enqueue_model(model)
        key = model.keys[0]
        unless model_queue.has_model?(model) && model_queue[key] == model[key]
          model_queue.add_model model
          @configured = false
        end
      end   
      
    end
    
    module ViewModelCommandOperations
      
      # gets or sets the command_queue to respond to user actions in the view.
      attr_accessor :command_queue
      
      def init_command_operations
        @command_queue = CommandCollection.new
      end 
      
      # flags the view model as in need of wiring up and 
      # sets the command collection
      def command_queue=(value)
        unless command_queue == value
          @configured = false 
          @command_queue = value
        end
      end
      
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
          cmd.add_observer(:refreshing_view) do |sender| 
            refresh_view(registry.view_for(sender.controller))
          end
          command_queue << cmd 
          @configured = false 
        end
      end
      
    end
    
    module ViewModelOperations
      
      # gets the view model instance to manipulate with this builder
      attr_accessor :view_models
      
      include ViewModelObjectOperations
      include ViewModelCommandOperations
      
      def init_viewmodel_operations
        init_object_operations
        init_command_operations
        @view_models = {}
      end
      
      def register_viewmodel_for(controller)
        # FIXME: The line below will be more useful when we can bind to IronRuby objects
        # Object.const_set options[:class_name], Class.new(ViewModel) unless Object.const_defined? options[:class_name]     
        
        # TODO: There is an issue with namespacing and CLR classes, they aren't registered as constants with
        #       IronRuby. This makes it hard to namespace viewmodels. If the namespace is included everything 
        #       should work as normally. Will revisit this later to properly fix it.        
        vm_name = controller.view_model_name
        klass = Object.const_get vm_name.camelize
        klass.include IronNails::View::ViewModelMixin
        key = vm_name.to_sym
        view_models[key] = klass.new if view_models[key].nil?
        registry.register_viewmodel_for controller, view_models[key]
        view_models[key]      
      end
      
    end
    
    class ComponentRegistryItem
      
      attr_accessor :viewmodel
      
      attr_accessor :view
      
      def initialize(options={})
        @view = options[:view]
        @viewmodel = options[:viewmodel]
      end    
      
    end
    
    class ComponentRegistry
      
      attr_accessor :components
      
      def initialize
        @components = {}
      end 
      
      def register(controller)
        components[controller.controller_name] = ComponentRegistryItem.new
      end
      
      def register_view_for(controller, view)
        find_controller(controller).view = view
      end
      
      def register_viewmodel_for(controller, model)
        find_controller(controller).viewmodel = model
      end
      
      def find_controller(controller)
        con_name = controller.respond_to?(:controller_name) ? controller.controller_name : controller.to_sym
        components[con_name]
      end 
      
      def viewmodel_for(controller)
        find_controller(controller).viewmodel
      end
      
      def view_for(controller)
        find_controller(controller).view
      end
    end
    
    # This could be viewed as the life support for the Nails framework
    # It serves as the glue between the different components.
    # One of its main functions is to manage communication between the controller,
    # view model and view.
    class NailsEngine
      
      include IronNails::Logging::ClassLogger
      include ControllerObservable
      include ViewOperations
      include ViewModelOperations
      
      # Stores the registered components and does lookup on them
      attr_accessor :registry
      
      def set_viewmodel_for(controller, key, value)
        model = registry.viewmodel_for controller
        model.set_model key, value
      end
      
      # configures the properties for the view model
      def configure_models(model)
        model_queue.each do |o|
          o.each do |k, v|
            model.add_model k, v
          end unless o.nil?
        end     
      end
      
      # processes the command queue.
      def configure_events(model, view)
        command_queue.each do |cmd|
          case 
          when cmd.is_a?(EventCommand)
            view.add_command(cmd)
          when cmd.is_a?(TimedCommand)
            view.add_timer(cmd)
          when cmd.is_a?(BehaviorCommand)
            model.add_command cmd
          end unless cmd.attached?
        end
      end
      
      # configures the view
      def configure_view(view)
        model = registry.viewmodel_for view.controller
        configure_models(model)
        configure_events(model, view)
        view.data_context = model unless view.has_datacontext? && !view.sets_datacontext?
        @configured = true
      end       
      
      # refreshes the data for the view.
      def refresh_view(view)
        notify_observers :refreshing_view, view.controller, self, view
        view.configure
        view.proxy.refresh
        @configured = true
      end
      
      # synchronises the data in the viewmodel with the controller
      def synchronise_with_controller
        notify_observers :reading_input, self, view
      end 
      
      def add_command_to_view(commands)
        add_commands_to_queue commands
      end
      
      def synchronise_to_controller(controller)
        objects = controller.instance_variable_get "@objects"
        model = registry.viewmodel_for controller #.objects.collect { |kvp| kvp.key.to_s.underscore.to_sym }
        objects.each do |k,v|
          if model.objects.contains_key(k.to_s.camelize)
            val = model.objects.get_value(k.to_s.camelize).value
            objects[k] = val
            controller.instance_variable_set "@#{k}", val
          end
        end
        view_properties = controller.instance_variable_get "@view_properties"
        view_properties.each do |k, v|
          val = from_view controller, (v[:view]||controller.view_name), v[:element], v[:property]
          instance_variable_set "@#{k}", val
        end
      end
      
      # returns whether this view needs configuration or not
      def configured?
        !!@configured
      end
      
      def initialize
        @configured, @registry = false, ComponentRegistry.new
        init_viewmodel_operations
        init_view_operations
      end
      
      def register_controller(controller)
        logger.debug "registering controller #{controller.controller_name}", IRONNAILS_FRAMEWORKNAME
        registry.register(controller)
        register_viewmodel_for controller
        register_view_for controller
        controller.nails_engine = self    
        logger.debug "controller #{controller.controller_name} registered", IRONNAILS_FRAMEWORKNAME    
      end
      
      def show_initial_window(controller)
        logger.debug "setting up controller", IRONNAILS_FRAMEWORKNAME
        #controller.setup_for_showing_view      
        registry.view_for(controller).load
        controller.default_action if controller.respond_to? :default_action
        controller.setup_for_showing_view      
        yield registry.view_for(controller).instance if block_given?
      end
      
      def initialize_with(command_definitions, models)
        add_commands_to_queue command_definitions
        add_models_to_queue_on models
        logger.debug "Added commands to queue on view manager.", IRONNAILS_FRAMEWORKNAME
        logger.debug "Added models to queue on view manager.", IRONNAILS_FRAMEWORKNAME
      end
      
    end
    
  end
  
end