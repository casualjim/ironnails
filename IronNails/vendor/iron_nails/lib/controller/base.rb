module IronNails

  module Controller
  
    class Base
      
      include IronNails::Controller::ViewOperations
      include IronNails::Logging::ClassLogger
      include IronNails::Core::Observable
      
      
      # Gets or sets the objects for the presenter
      attr_accessor :objects
      
      # Gets or sets the commands for the presenter
      attr_accessor :commands
      
      # Gets or sets the presenters collection for this controller
      attr_accessor :presenters
      
      def controller_name
        self.class.to_s.underscore.to_sym
      end
            
      def show_view
        #log_on_error do
          setup_for_showing_view        
          main_presenter.show_view
        #end
      end
      
      def on_view(name=nil, &b)
        view_manager.on_view(controller_name, name, &b)
      end
      
      def child_view(view_name, options)
        view_manager.register_child_view :controller => controller_name, :container => options[:in], :name => view_name
      end
      
      def configure_viewmodel_for_showing
        view_manager.configure_view_for_showing
      end
      
      def init_controller
      end
      
      def __init_controller__
        @command_builder = CommandBuilder.new self
        init_controller
      end
     
                  
      class << self
        
        alias_method :old_nails_controller_new, :new
        def new
          ctrlr = old_nails_controller_new
          ctrlr.__init_controller__
          ctrlr
        end  
        
        def view_action(name, options={}, &b)
          @commands ||= {}
          options[:action] = b if block_given?
          @commands[name] = options          
        end
        
        def view_object(name, options = nil)
          @objects ||= {}
          attr_accessor name
          instance_variable_set("@#{name}", (options.is_a?(Hash) ? options[:value] : options))
          @objects[name] = options
        end
      
      end
    end
    
  end
  
end