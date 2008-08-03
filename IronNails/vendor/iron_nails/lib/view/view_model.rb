module IronNails

  module View
  
    class ViewModel
      
      # the view proxy that this view model is responsible for
      attr_accessor :view
      
      # gets or sets the commands to respond to user actions in the view.
      attr_accessor :commands
      
      # gets or sets the models that wil be used in the view to bind to
      attr_accessor :objects
      
      def load_view(name)
        @view = Proxy.load(name)
      end 
      
      def initialize
        @commands, @objects = [], []        
      end
      
      
    end
    
    class ViewModelBuilder
      
      attr_accessor :model
      
      def load_view(name)
        @model.load_view name
      end
      
      def view_instance
        @model.view.instance
      end
      
      def copyvars
        self.class.instance_variables.each do var
          instance_variable_set(var, self.class.instance_variable_get(var))
        end
      end
      
      def build_class_with(class_name, view_name)
        Object.const_set class_name, Class.new(IronNails::View::ViewModel) unless Object.const_defined? class_name     
        klass = Object.const_get class_name
        @model = klass.new     
        @model.load_view view_name
        @model
      end
      
      class << self
      
        # initializes a new view model class for the controller 
        def for_view_model(class_name, view_name)
          builder = new
          builder.build_class_with class_name.camelize, view_name
          builder
        end
        
        def singleton_class
          class << self; self; end;
        end
          
      end
      
    end
      
  end
  
end