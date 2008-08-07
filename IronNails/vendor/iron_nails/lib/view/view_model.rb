require File.dirname(__FILE__) + "/command.rb"
module IronNails

  module View
    
    class ViewModel
      def initialize(name = '')
        super
      end
    end
    
    # The base class for view models in an IronNails application.
    module ViewModelMixin 
      
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
      
      
      def wireup_properties
        @objects.each do |o|
          o.each do |k, v|
            send "#{k}=".to_sym, v 
          end
        end        
      end
      
      def wireup_events
        @commands.each do |cmd|
          cmd.attach_to view
        end
      end
      
      # binds the view model to the view. It will setup the appropriate events, 
      # set the datacontext of the view so that all the data appears properly.s      
      def wireup_view
        wireup_properties
        wireup_events
        @view.instance.data_context = self
      end
             
    end
    
    class ViewModelBuilder
      
      # gets the view model instance to manipulate with this builder
      attr_reader :model
      
      # loads a new instance of the view into memory
      def load_view(name)
        @model.load_view name
      end
      
      # gets the view proxy      
      def view
        @model.view
      end
      
      # builds a class with the specified +class_name+ and defines it if necessary. 
      # After it will load the proxy for the view with +view_name+
      def build_class_with(class_name, view_name)
        # FIXME: The line below will be more useful when we can bind to IronRuby objects
        # Object.const_set class_name, Class.new(ViewModel) unless Object.const_defined? class_name     

        # TODO: There is an issue with namespacing and CLR classes, they aren't registered as constants with
        #       IronRuby. This makes it hard to namespace viewmodels. If the namespace is included everything 
        #       should work as normally. Will revisit this later to properly fix it.        
        klass = Object.const_get class_name 
        klass.include IronNails::View::ViewModelMixin
        @model = klass.new 
        @model.load_view view_name        
        @model
      end
      
      def initialize_with(command_definitions, objects)
        @model.commands += IronNails::View::Command.generate_for command_definitions
        @model.objects << objects
        @model.wireup_view
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