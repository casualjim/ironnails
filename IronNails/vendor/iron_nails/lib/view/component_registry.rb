module IronNails

  module View
  
    class ComponentRegistryItem
    
      attr_accessor :viewmodel
      
      attr_accessor :view
      
      def initialize(options={})
        @view = options[:view]
        @viewmodel = options[:viewmodel]
      end    
      
    end
    
    class ComponentRegistry
    
      attr_accessor :components
      
      def initialize
        @components = {}
      end 
      
      def register(controller)
        components[controller.controller_name] = ComponentRegistryItem.new
      end
      
      def register_view_for(controller, view)
        find_controller(controller).view = view
      end
      
      def register_viewmodel_for(controller, model)
        find_controller(controller).viewmodel = model
      end
      
      def find_controller(controller)
        con_name = controller.respond_to?(:controller_name) ? controller.controller_name : controller.to_sym
        components[con_name]
      end 
      
      def viewmodel_for(controller)
        find_controller(controller).viewmodel
      end
      
      def view_for(controller)
        find_controller(controller).view
      end
    end
    
  end
  
end