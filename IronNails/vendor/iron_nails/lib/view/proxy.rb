module IronNails

  module View
    
    # The IronNails::View::Proxy class wraps a xaml file and brings it alive
    class Proxy
      
      include IronNails::Logging::ClassLogger
      
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
      
      # Adds the specified +command+ to this view
      def add_command(command)
        command.view = self
#        command.attach
        ele = (command.affinity || command.element).to_sym
        send(command.element.to_sym).send(command.trigger.to_sym) do 
          on_ui_thread(ele) do
            command.execute
          end
        end
      end
      
      def on_ui_thread(element=:instance, &b)
        send(element).dispatcher.begin_invoke(DispatcherPriority.normal, Action.new(&b))
      end
      
      # shows the proxied view
      def show
        WpfApplication.current.has_main_window? ? instance.show : instance
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
          vw = new view_name
          vw.load_view
          vw
        end
      end
      
    end
  
  end
  
end