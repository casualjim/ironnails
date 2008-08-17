module IronNails

  module View
  
    class BehaviorCommand < Command
    
      def to_clr_command
        asynchronous? ? delegate_command.new(Action.new(action), Action.new(method(:can_execute?))) : async_delegate_command.new(Action.new(action), 
                                                            Action.new(method(:refresh_view)), 
                                                            Action.new(method(:can_execute?)))
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