module Sails

  module View
  
    class ViewModel
      
      # the view proxy that this view model is responsible for
      attr_accessor :view
      
      def init_with(view_name)
        @view = Proxy.load(view_name)
      end 
      
      
    end
  
  end
  
end