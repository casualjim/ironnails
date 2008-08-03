module IronNails

  module View
  
    # The base class for view models in an IronNails application.
    class ViewModel
      
      # the view proxy that this view model is responsible for
      attr_accessor :view
      
      # gets or sets the commands to respond to user actions in the view.
      attr_accessor :commands
      
      # gets or sets the models that wil be used in the view to bind to
      attr_accessor :objects
      
      # loads a new instance of a view proxy into this model
      def load_view(name)
        @view = Proxy.load(name)
      end 
      
      def initialize(view_name='')
        @commands, @objects = [], []        
        load_view view_name unless view_name.empty?
      end
            
    end
    
    class ViewModelBuilder
      
      # gets the view model instance to manipulate with this builder
      attr_reader :model
      
      # loads a new instance of the view into memory
      def load_view(name)
        @model.load_view name
      end
      
      # adds a command to the view model
      def add_command(command)
        @model.commands << command
      end
      
      # adds an object to the view model
      def add_object(object)
        @model.objects << object
      end 
      
      # gets the view proxy      
      def view
        @model.view
      end
      
      # builds a class with the specified +class_name+ and defines it if necessary. 
      # After it will load the proxy for the view with +view_name+
      def build_class_with(class_name, view_name)
        Object.const_set class_name, Class.new(IronNails::View::ViewModel) unless Object.const_defined? class_name     
        klass = Object.const_get class_name
        @model = klass.new view_name
        @model
      end
      
      class << self
      
        # initializes a new view model class for the controller 
        def for_view_model(class_name, view_name)
          builder = new
          builder.build_class_with class_name.camelize, view_name
          builder
        end       
          
      end
      
    end
      
  end
  
end