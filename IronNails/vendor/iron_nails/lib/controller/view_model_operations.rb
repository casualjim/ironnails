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
        cmd_defs = generate_command_definitions 
        @view_model.initialize_with cmd_defs, @objects
      end
      
      # Generates the command definitions for our view model.
      # When it can't find a key :action in the options hash for the view_action
      # it will default to using the name as the command as the connected option.
      # It will generate a series of commands for items that have more than one trigger      
      def generate_command_definitions
        command_definitions = []
        @commands.each do |k, v|
          raise ArgumentException.new "You have to specify at least one trigger for a view action" if v[:triggers].nil?
          act = v[:action]||k
          action = act
          action = self.object.method(act) if act.is_a?(Symbol) || act.is_a?(String)
          triggers = v[:triggers]
          command_definitions << { :element => triggers, :event => :click, :action => action } if triggers.is_a?(String) || triggers.is_a?(Symbol)
          command_definitions << triggers.merge({:action => action }) if triggers.is_a?(Hash)
          triggers.each do |trig|
            trig = { :element => trig, :event => :click } unless trig.is_a? Hash
            trig[:event] = :click unless trig.respond_to? :event
            command_definitions << trig.merge({ :action => action })
          end if triggers.is_a?(Array)
        end
        command_definitions
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