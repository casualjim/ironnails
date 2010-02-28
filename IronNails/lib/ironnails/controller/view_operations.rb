module IronNails

  module Controller

    # Encapsulates all the operations that have to do with the 
    # view model in controllers.
    module ViewOperations

      attr_accessor :nails_engine

      # gets the view name for the class that includes this module
      def view_name
        self.class.demodulize.underscore.gsub(/_controller$/, '')
      end

      # gets the name of the view model class
      def view_model_name
        "#{view_name}_view_model"
      end

      def nails_engine=(value)
        @nails_engine = value
        init_view_manager
      end

      # initializes a new instance of the ViewManager      
      def init_view_manager

        nails_engine.add_observer :refreshing_view, controller_name do
          setup_for_showing_view
        end
        copy_vars
        #end
      end

      def synchronise_with_view_model
        nails_engine.synchronise_to_controller self
        refresh_instance_variables
      end

      # setup the viewmodel for the current objects and command defintions
      def setup_for_showing_view
        #log_on_error do
        objs = ModelCollection.generate_for refresh_objects
        cmds = @command_builder.generate_for commands
        cmds.each do |cmd|
          cmd.add_observer(:reading_input) do
            synchronise_with_view_model
          end
        end
        nails_engine.initialize_with cmds, objs
        logger.debug "initialized the view manager", IRONNAILS_FRAMEWORKNAME
        #end
      end

      def add_action(name, options, &b)
        options[:action] = b if block_given?
        cmd_def = { "#{name}".to_sym => options }
        nails_engine.add_command_to_view cmd_def
      end

      def refresh_objects
        instance_variables.each do |var|
          sym = var.gsub(/@/, "").to_sym
          if objects.has_key?(sym)
            val = instance_variable_get(var)
            objects[sym] = val
          end
        end
        objects
      end

      def refresh_instance_variables
        objects.each do |k, v|
          instance_variable_set "@#{k}", v
        end
        view_properties.each do |k, v|
          val = on_view v[:view], :from => v[:element], :get => v[:property]
          instance_variable_set "@#{k}", val
        end
      end

      # copies an instance variable from the class object to this instance
      def instance_variable_copy(var)
        log_on_error do
          val = self.class.instance_variable_get var
          instance_variable_set var, val
        end
      end

      # copies the instance variables from the class object to this instance
      def copy_vars
        self.class.instance_variables.each { |var| instance_variable_copy var }
      end


    end

  end

end