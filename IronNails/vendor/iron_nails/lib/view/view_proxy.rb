module IronNails

  module View
  
    module Extensions
    
      module ThreadingSupport
        
        def on_ui_thread(element=:instance, &b)
          send(element).dispatcher.begin_invoke(DispatcherPriority.normal, Action.new(&b))
        end
        
        # Schedules this command to execute on a different thread 
        # and schedules the update of the view on the UI thread. 
        def on_new_thread(request, &b)
          cb = WaitCallback.new do
            begin
              # b.call
              blk = lambda { |obj| b.call }
              instance.dispatcher.begin_invoke(DispatcherPriority.normal, Action.of(System::Object).new(&blk), request.call )
            rescue Exception => e
              MessageBox.Show("There was a problem. #{e.message}")          
            end
          end
          ThreadPool.queue_user_work_item cb        
        end
         
      end
      
      module CommandSupport
        
        include IronNails::View::Extensions::ThreadingSupport
        
        def execute_command(command)
          unless command.asynchronous?
            command.execute
          else
            on_new_thread(lambda { command.execute }) { command.refresh_view }              
          end
        end
        
      end
  
      module TimerSupport
        
        include IronNails::View::Extensions::CommandSupport
        
        def add_timer(command)
          command.view = self
          @attached = false
          instance_variable_set "@#{command.timer_name}", DispatcherTimer.new
        end
        
        def start_timer(command)
          ti = get_timer_for command
          ti.tick do 
            execute_command command if command.can_execute?
          end unless attached?
          @attached = true    
          ti.start
        end 
        
        def attached?
          !!@attached
        end
        
        def stop_timer(command)
          ti = get_timer_for command
          ti.stop
        end
        
        private 
        
          def get_timer_for(command)
            instance_variable_get "@#{command.timer_name}"
          end
        
      end
      
      module EventSupport
      
        include IronNails::View::Extensions::CommandSupport
              
        # Adds the specified +command+ to this view
        def add_command(command)
          command.view = self
          ele = (command.affinity || command.element).to_sym
          send(command.element.to_sym).send(command.trigger.to_sym) do 
            on_ui_thread(ele) do
              execute_command command
            end if command.can_execute?
          end
        end
        
      end
      
      module SubViewSupport
      
#        def add_sub_view(command)
#          command.view = self
#          command.execute if command.can_execute?
#        end
                
        # Adds a subview to the current view.
        def add_control(target, view)
          parent = send(target)
          if parent.respond_to? :content=
            parent.content = view
          elsif parent.respond_to? :children
            parent.children.add view
          end          
        end
        
      end
    
    end
    
    # The IronNails::View::ViewProxy class wraps a xaml file and brings it alive
    class ViewProxy
      
      include IronNails::Logging::ClassLogger
      include IronNails::View::Extensions::EventSupport
      include IronNails::View::Extensions::TimerSupport
      include IronNails::View::Extensions::SubViewSupport
      include IronNails::Core::Observable
      
      # gets or sets the name of the view
      attr_accessor :view_name
      
      # gets the instance of the view
      attr_reader :instance
      
      # gets or sets the extension for the view file. 
      # defaults to xaml
      attr_accessor :view_extension
      
      # gets the path to the view file
      attr_reader :view_path
      
      def initialize(name)
        @view_name = name
        @view_extension = ".xaml" 
      end
      
      # loads the view into the instance variable
      def load_view
        @instance = XamlReader.load_from_path view_path if File.exists? view_path
      end 
      
      # returns the path to the file for the current view.
      # this is the file we'll be the proxy for
      def view_path
        path = "#{IRONNAILS_VIEWS_ROOT}/#{view_name}#{view_extension}"
        @view_path = path unless @view_path == path
        @view_path
      end
            
      # shows the proxied view
      def show
        WpfApplication.current.has_main_window? ? instance.show : instance
      end
      
      def invoke(element, method, *args, &b)
        instance.send(element.to_s.to_sym).send(method.to_s.to_sym, *args, &b)
      end
      
      def method_missing(sym, *args, &blk)
        # First we check if we can find a named control
        # When we can't find a control we'll check if we can find
        # a method on the view instance by that name, if that is the 
        # case we will call that method otherwise we'll return the control 
        # if we found one. When no method or control could be found we 
        # delegate to the default behavior
        obj = @instance.find_name(sym.to_s.to_clr_string)
        nmsym = sym.to_s.camelize.to_sym
        if @instance.respond_to?(nmsym) && obj.nil?
          @instance.send sym, args, &blk
        else
          obj.nil? ? super : obj
        end
      end 
      
      class << self
        
        # creates an instance of the view specified by the +view_name+
        def load(view_name)
          vw = new view_name.to_s
          vw.load_view
          vw
        end
      end
      
    end
  
  end
  
end