module Sails

  module Controller
  
    class Base
      
      include Sails::Controller::AsyncOperations
      
      # Gets or sets the view_model for this controller.
      attr_accessor :view_model
      
      def initialize
        puts "in base initialize"
      end
      
      def current_view 
        @view_model.view.instance
      end
      
      def view_name
        self.class.demodulize.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase.gsub(/_controller$/, '')
      end
      
      def view_model_name
        "#{view_name.camelize}ViewModel"
      end
      
      def init_view_model
        @view_model = Sails::View::ViewModel.new   
        @view_model.init_with view_name
        @view_model
      end
      
      class << self
        
        alias_method :old_sails_new, :new
        def new
          ctrlr = old_sails_new
          ctrlr.init_view_model
          ctrlr
        end       
      
      end
    end
    
  end
  
end