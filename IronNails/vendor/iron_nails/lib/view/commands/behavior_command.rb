module IronNails

  module View
  
    class BehaviorCommand < Command
    
      def to_clr_command
        # I have to wrap the method calls into blocks because .to_proc hasn't been implemented yet on method
#        unless asynchronous?
          delegate_command.new(Action.new { execute }, Func[System::Boolean].new(&lambda{ can_execute? } )) 
#        else  
#          async_delegate_command.new(Action.new(&action), Action.new { refresh_view }, 
#                                                            Func[System::Boolean].new(&lambda{ can_execute? }))
#        end
      end
      
      def delegate_command
        IronNails::Library::DelegateCommand
      end
      
      def async_delegate_command
        IronNails::Library::AsynchronousDelegateCommand
      end
    end
  
  end

end