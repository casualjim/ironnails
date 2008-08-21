module IronNails

  module Controller
  
    class Base
      
      include IronNails::Controller::ViewModelOperations
      include IronNails::Logging::ClassLogger
      
      
      # Gets or sets the objects for the view model
      attr_accessor :objects
      
      # Gets or sets the commands for the view model
      attr_accessor :commands
      
      def current_view 
        @view_model.view
      end
            
      def show_view
        #log_on_error do
          setup_for_showing_view        
          view_model.show_view
        #end
      end
      
      def add_child_view(target, view_name)
        controller = "#{view_name.camelize}Controller".classify.new
        controller.setup_for_showing_view
        current_view.add_control(target, controller.current_view.instance)
      end
                  
      class << self
        
        alias_method :old_nails_controller_new, :new
        def new
          ctrlr = old_nails_controller_new
          ctrlr.init_view_model
          ctrlr
        end  
        
        def view_action(name, options={}, &b)
          @commands ||= {}
          options[:action] = b if block_given?
          @commands[name] = options          
        end
        
        def view_object(name, options)
          @objects ||= {}
          attr_accessor name
          instance_variable_set("@#{name}", (options.is_a?(Hash) ? options[:value] : options))
          @objects[name] = options
        end
      
      end
    end
    
  end
  
end