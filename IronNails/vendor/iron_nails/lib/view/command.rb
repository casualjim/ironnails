module IronNails

  module View
  
    # Encapsulates commands that will be attached to the views.
    class Command
    
      include IronNails::Logging::ClassLogger
    
      # the name of the event that will trigger the action
      attr_accessor :trigger
      
      # the name of the element that will trigger the action
      attr_accessor :element
      
      # the action that will be triggered 
      attr_accessor :action
      
      # the view this command is bound to
      attr_accessor :view
      
      # the view model to which this command belongs
      attr_reader :view_model
      
      # indicates whether to execute this command on the ui thread or on a different thread.
      attr_accessor :mode
      
      # the name of the on which this command needs to be invoked
      attr_accessor :affinity
            
      def initialize(options)
        raise ArgumentException.new("An element name is necesary") if options[:element].nil?
        raise ArgumentException.new("An action is necesary") if options[:action].nil?
        
        @trigger = options[:event]||:click
        @element = options[:element]
        @action = options[:action]
        @view_model = options[:view_model]
        @mode = options[:mode]||:synchronous
        @affinity = options[:affinity]
      end 
      
      # executes this command (it calls the action)
      def execute
        log_on_error do
          if mode == :asynchronous 
            on_new_thread do
              action.call
              view_model.refresh_view
            end                 
          else
            action.call
            view_model.refresh_view
          end
        end
      end
    
      # Schedules this command to execute on a different thread 
      # and schedules the update of the view on the UI thread. 
      def on_new_thread(&b)
        cb = WaitCallback.new do
          begin
            view.dispatcher.begin_invoke(DispatcherPriority.normal, Action.new(&b))
          rescue Exception => e
            MessageBox.Show("There was a problem. #{e.message}")          
          end
        end
        ThreadPool.queue_user_work_item cb        
      end 
      
    end
  
  end

end