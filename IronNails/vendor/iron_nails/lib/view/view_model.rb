module IronNails

  module View
    
    # The base class for view models in an IronNails application.
    module ViewModelMixin 
    
      include IronNails::Logging::ClassLogger
      
      def initialize()
        initialize_dictionaries
      end
      
      def __view_model_name_
        self.class.demodulize.underscore
      end
    
      # adds a model for the view in the dictionary
      def add_model(k, v)
        key = k.to_s.camelize
        changed = false
        logger.debug "trying to set model #{key} to value: #{v}", IRONNAILS_FRAMEWORKNAME
        wpf_value = unless objects.contains_key(key) 
          changed = true
          IronNails::Library::WpfValue.of(System::Object).new(v)
        else
          val = objects.get_value(key)
          unless v == val.value
            val.value = v
            changed = true
          end
          val          
        end
        if changed
          logger.debug "setting objects entry: { #{key}: #{v} }", IRONNAILS_FRAMEWORKNAME
          objects.set_entry(key, wpf_value)
        end
      end
      alias_method :set_model, :add_model
      
      # configures a command appropriately on the view.
      # for an EventCommand it will pass it to the view and the view will attach the
      # appropriate events
      # for a TimedCommand it will create a timer in the view proxy object
      # for a BehaviorCommand it will add the appropriate delegate command to the 
      # Commands dictionary on the ViewModel class
      def add_command(cmd)
        dc = cmd.to_clr_command
        cmd_name = cmd.name.to_s.camelize
        unless commands.contains_key(cmd_name)
          logger.debug "adding command to the view #{cmd.name}", IRONNAILS_FRAMEWORKNAME
          commands.set_entry(cmd_name, dc) 
        end
      end
            
    end
      
  end
  
end