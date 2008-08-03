module IronNails

  module Controller
  
    class Base
      
      include IronNails::Controller::AsyncOperations
      include IronNails::Controller::ViewModelOperations
      
      # Gets or sets the view_model for this controller.
      attr_accessor :view_model
      
      def current_view 
        @view_model.model.view
      end
      
            
      class << self
        
        alias_method :old_nails_new, :new
        def new
          ctrlr = old_nails_new
          ctrlr.init_view_model
          ctrlr.copy_vars
          ctrlr
        end  
        
        def view_action(name, options)
          @commands ||= {}
          @commands[name] = options          
        end
        
        def view_object(name, options)
          @objects ||= {}
          @objects[name] = options
        end
      
      end
    end
    
  end
  
end