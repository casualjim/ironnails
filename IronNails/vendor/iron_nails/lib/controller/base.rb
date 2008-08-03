module IronNails

  module Controller
  
    class Base
      
      include IronNails::Controller::AsyncOperations
      
      # Gets or sets the view_model for this controller.
      attr_accessor :view_model
      
      def initialize
        puts "in base initialize"
      end
      
      def current_view 
        @view_model.model.view
      end
      
      def view_name
        self.class.demodulize.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase.gsub(/_controller$/, '')
      end
      
      def view_model_name
        "#{view_name.camelize}ViewModel"
      end
      
      def default_namespace
        "::IronNails::ViewModels::"
      end
      
      def init_view_model
        @view_model = IronNails::View::ViewModelBuilder.for_view_model view_model_name, view_name
      end
      
      def copy_instance_var(var)
        instance_variable_set(var, self.class.instance_var_get(var))
      end
      
      class << self
        
        alias_method :old_sails_new, :new
        def new
          ctrlr = old_sails_new
          ctrlr.init_view_model
          ctrlr
        end       
      
      end
    end
    
  end
  
end