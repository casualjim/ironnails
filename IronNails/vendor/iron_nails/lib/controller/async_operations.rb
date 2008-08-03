module IronNails
  
  module Controller
    
    module AsyncOperations
      
      def to_update_ui_after(options, &b)
        if options.is_a? Hash
          klass = options[:class]||ObservableCollection.of(System::Object)
          request = options[:request]
        else
          klass = ObservableCollection.of(System::Object)
          request = options
        end
        cb = System::Threading::WaitCallback.new do
          begin
            view.dispatcher.begin_invoke(DispatcherPriority.normal, Action.of(klass).new(&b), request.call)
          rescue Exception => e
            MessageBox.Show("There was a problem. #{e.message}")          
          end
        end
        System::Threading::ThreadPool.queue_user_work_item cb        
      end 
      alias_method :to_update_ui_for, :to_update_ui_after
      
      def on_ui_thread(options=nil, &b)
        if options.is_a? Hash
          data = options[:data]
          klass = options[:class] || data.class
        else
          unless options.nil?
            klass = options.class    
            data = options
          end
        end
        view.dispatcher.begin_invoke(DispatcherPriority.normal, options.nil? ? Voidhandler.new(&b) : Action.of(klass).new(&b), data)
      end
      alias_method :on_ui_thread_with, :on_ui_thread
      
    end
    
  end
  
end