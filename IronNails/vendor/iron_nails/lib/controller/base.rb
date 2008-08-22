module IronNails

  module Controller
  
    class Base
      
      include IronNails::Controller::PresenterOperations
      include IronNails::Logging::ClassLogger
      include IronNails::Core::Observable
      
      
      # Gets or sets the objects for the presenter
      attr_accessor :objects
      
      # Gets or sets the commands for the presenter
      attr_accessor :commands
      
      # Gets or sets the presenters collection for this controller
      attr_accessor :presenters
      
      def current_view 
        main_presenter.view
      end
            
      def show_view
        #log_on_error do
          setup_for_showing_view        
          main_presenter.show_view
        #end
      end
      
      def add_child_view(target, view_name)
        controller = nil
        unless @presenters.include?({ view_name => target })
          controller = "#{view_name.to_s.camelize}Controller".classify.new
          controller.setup_for_showing_view
          controller.configure_viewmodel_for_showing
          @presenters << { view_name => target }
          current_view.add_control(target, controller.current_view.instance)
        end
        puts "Nr. of views: #{presenters.size}"
        controller
      end
      
      def configure_viewmodel_for_showing
        main_presenter.configure_view_for_showing
      end
      
      def init_controller
      end
      
      def __init_controller__
        init_controller
        init_presenter
        @presenters = [main_presenter]
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