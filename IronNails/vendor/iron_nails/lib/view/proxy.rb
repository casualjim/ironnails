module IronNails

  module View
    
    # The IronNails::View::Proxy class wraps a xaml file and brings it alive
    class Proxy
      
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
      
      
      def method_missing(sym, *args, &blk)
        obj = @instance.find_name(sym.to_s.to_clr_string)
        obj.nil? ? super : obj
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