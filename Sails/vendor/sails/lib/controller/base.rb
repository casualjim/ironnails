module Sails

  module Controller
  
    class Base
      
      include Sails::Controller::AsyncOperations
      
      attr_reader :view, :view_name, :view_extension, :view_path
      
      def initialize
        initialize_controls
        initialize_events   
      end
      
      def load_view
        @view = XamlReader.load_from_path view_path if File.exists? view_path
      end  
      
      def initialize_events
        
      end
      
      def initialize_controls
        
      end
      
      def view_name
        self.class.demodulize.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase.gsub(/_controller$/, '')
      end
      
      def view_extension
        ".xaml"
      end
      
      def view_path
        "#{SAILS_VIEWS_ROOT}/#{view_name}#{view_extension}"
      end
      
      def method_missing(sym, *args, &blk)
        @view.find_name(sym.to_s.to_clr_string)
      end
      
      def app_settings
        APP_SETTINGS
      end
      
    end
    
  end
  
end