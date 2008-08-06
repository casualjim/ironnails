module IronNails

  module Controller
  
    module ViewModelOperations
      
      def view_name
        self.class.demodulize.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase.gsub(/_controller$/, '')
      end
      
      def view_model_name
        "#{default_vm_namespace}#{view_name.camelize}ViewModel"
      end
      
      def default_vm_namespace
        #"IronNails::ViewModels::"
        ""
      end
      
      def init_view_model
        @view_model = IronNails::View::ViewModelBuilder.for_view_model view_model_name, view_name
        copy_vars
        @view_model.initialize_with @commands, @objects
      end
      
      def instance_variable_copy(var)
        val = self.class.instance_variable_get var
        instance_variable_set var, val
      end
      
      # copies the instance variables from the class object to this instance
      def copy_vars
        self.class.instance_variables.each { |var| instance_variable_copy var }
      end
      
      
    end
  
  end

end