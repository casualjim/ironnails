module IronNails

  module View
    
    # The base class for view models in an IronNails application.
    module ViewModelMixin 
    
      def initialize()
        initialize_dictionaries
      end
    
      # adds a model for the view in the dictionary
      def add_model(k, v)
        key = k.to_s.camelize
        changed = false
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
          puts "setting objects entry: { #{key}: #{v} }"
          objects.set_entry(key, wpf_value)
        end
      end
      
      # configures a command appropriately on the view.
      # for an EventCommand it will pass it to the view and the view will attach the
      # appropriate events
      # for a TimedCommand it will create a timer in the view proxy object
      # for a BehaviorCommand it will add the appropriate delegate command to the 
      # Commands dictionary on the ViewModel class
      def add_command_to_view(cmd)
        case 
        when cmd.is_a?(EventCommand)
          view.add_command(cmd)
        when cmd.is_a?(TimedCommand)
          view.add_timer(cmd)
        when cmd.is_a?(BehaviorCommand)
          dc = cmd.to_clr_command
          cmd_name = cmd.name.to_s.camelize
          unless commands.contains_key(cmd_name)
            puts "adding command to the view #{cmd.name}"
            commands.set_entry(cmd_name, dc) 
          end
        end
      end
            
    end
      
  end
  
end