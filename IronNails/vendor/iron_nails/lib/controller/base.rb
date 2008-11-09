require File.dirname(__FILE__) + '/view_operations'
module IronNails

  module Controller
  
    class Base
      
      include IronNails::Controller::ViewOperations
      include IronNails::Logging::ClassLogger
      include IronNails::Core::Observable
      
      
      # Gets or sets the objects for the presenter
      attr_accessor :objects
      
      # Gets or sets the meta data for binding ui stuff we can't with Xaml (like Password on the PasswordBox)
      attr_accessor :view_properties
      
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
      
      def refresh_view(name=nil)
        name ||= view_name.to_sym
        setup_for_showing_view
		nails_engine.refresh_view(nails_engine.find_view(controller_name, name))
		on_view(name) do |proxy|
		  proxy.refresh
		end
      end
      
      def on_view(name=nil, options={}, &b)
        name ||= view_name.to_sym
        if block_given?
		  setup_for_showing_view
          nails_engine.on_view(controller_name, name, &b)         
        else
          if options[:set].nil?
            nails_engine.from_view(controller_name, name, options[:from], options[:get])
          else
            nails_engine.set_on_view(controller_name, name, options[:from], options[:set], options[:value])
          end
        end
      end
      
#      def from_view(name, options)
#        name ||= view_name.to_sym
#        nails_engine.from_view(controller_name, name, options[:from], options[:get])
#      end
      
      def child_view(view_name, options)
        nails_engine.register_child_view :controller => controller_name, :container => options[:in], :name => view_name
      end
      
      def view_model(model_name, value)
        instance_variable_set "@#{model_name}", value
        refresh_objects
        nails_engine.set_viewmodel_for self, model_name, value
      end
      
      def configure_viewmodel_for_showing
        nails_engine.configure_view_for_showing
      end
      
      def to_update_ui_after(options, &b)
        nails_engine.to_update_ui_after self, options, &b
      end
      
      def on_ui_thread(options=nil, &b)
        nails_engine.on_ui_thread self, options, &b
      end
      
      def play_storyboard(name=nil, storyboard=nil)
        nails_engine.play_storyboard self, (storyboard.nil? ? view_name : name), (storyboard.nil? ? name : storyboard)
      end
      
      def stop_storyboard(name=nil, storyboard=nil)
        nails_engine.stop_storyboard self,  (storyboard.nil? ? view_name : name), (storyboard.nil? ? name : storyboard)
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
          @view_properties ||={}
          unless options.is_a?(Hash) && !options[:element].nil?
            @objects[name] = options.is_a?(Hash) ? options[:value] : options
          else
            @view_properties[name] = options
          end
          
        end
      
      end
    end
    
  end
  
end