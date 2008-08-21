module IronNails

  module Controller
  
    # Encapsulates all the operations that have to do with the 
    # view model in controllers.
    module ViewModelOperations
      
      # Gets or sets the view_model for this controller.
      attr_accessor :view_model
            
      # gets the view name for the class that includes this module
      def view_name
        self.class.demodulize.underscore.gsub(/_controller$/, '')
      end
      
      # gets the name of the view model class
      def view_model_name
        "#{default_vm_namespace}#{view_name.camelize}ViewModel"
      end
      
      def viewmodel_class
        view_model.viewmodel_class
      end 
      
      # gets the default namespace for the view model class
      def default_vm_namespace
        #"IronNails::ViewModels::"
        ""
      end
      
      # initializes a new instance of the ViewModelBuilder      
      def init_view_model
        #log_on_error do
          @view_model = ViewModelBuilder.for_view_model :class_name => view_model_name, 
                                                        :view_name => view_name
                                                        
          @view_model.add_observer :refreshing_view { setup_for_showing_view }
          @view_model.add_observer :reading_input { synchronise_with_viewmodel }
          copy_vars
        #end
      end
      
      def synchronise_with_viewmodel
        view_model.synchronise_to_controller self
      end 
      
      # setup the viewmodel for the current objects and command defintions
      def setup_for_showing_view
        #log_on_error do
          objs = refresh_objects
          @view_model.initialize_with commands, objs, self
        #end
      end
      
      def add_action(name, options, &b)
        options[:action] = b if block_given?
        cmd_def = { "#{name}".to_sym => options }
        @view_model.add_command_to_view cmd_def
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