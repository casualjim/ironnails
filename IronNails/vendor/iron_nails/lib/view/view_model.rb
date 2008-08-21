module IronNails

  module View
    
    # The base class for view models in an IronNails application.
    module ViewModelMixin 
      
      include IronNails::Logging::ClassLogger
      include IronNails::Core::Observable
      
      # the view proxy that this view model is responsible for
      attr_accessor :view
      
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
      
      # loads a new instance of a view proxy into this model
      def set_view_name(name)
        @view_name = name
      end 
      
      def initialize(view_name='')
        @configured, @command_queue, @model_queue = false, CommandCollection.new, ModelCollection.new
        set_view_name view_name unless view_name.empty?
        initialize_dictionaries
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
      def configure_models
        model_queue.each do |o|
          o.each do |k, v|
            key = k.to_s.camelize
            wpf_value = unless objects.contains_key(key) 
              IronNails::Library::WpfValue.of(System::Object).new(v)
            else
              val = objects.get_value(key)
              val.value = v
              val
            end
            objects.set_entry(key, wpf_value)
          end unless o.nil?
        end     
      end
      
      # configures a command appropriately on the view.
      # for an EventCommand it will pass it to the view and the view will attach the
      # appropriate events
      # for a TimedCommand it will create a timer in the view proxy object
      # for a BehaviorCommand it will add the appropriate delegate command to the 
      # Commands dictionary on the ViewModel class
      def add_command_to_view(cmd)
        case 
        when cmd.is_a?(EventCommand)
          view.add_command(cmd)
        when cmd.is_a?(TimedCommand)
          view.add_timer(cmd)
        when cmd.is_a?(BehaviorCommand)
          dc = cmd.to_clr_command
          commands.set_entry(cmd.name.to_s, dc)
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
      
      # processes the command queue.
      def configure_events
        command_queue.each do |cmd|
          add_command_to_view cmd unless cmd.attached?
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
        configure_models
        configure_events
        view.data_context = self
        @configured = true
      end
      
#      # sets the refresh view function for asynchronous operations
#      def set_refresh_view(&refresh)
#        @refresh_view = refresh
#      end
      
      # refreshes the data for the view.
      def refresh_view
        notify_observers :refreshing_view, self
        configure_models
        configure_events
        @configured = true
      end
      
#      # sets the synchronise to controller function
#      def set_synchronise(&synchronise)
#        @synchronise = synchronise
#      end 
      
      # synchronises the data in the viewmodel with the controller
      def synchronise_with_controller
        notify_observers :reading_input, self
      end 
      
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
      
  end
  
end