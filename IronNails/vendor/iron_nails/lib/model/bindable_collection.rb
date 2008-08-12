module IronNails
  
  module Models
    
    class BindableCollection
      
      def initialize(list)
        list.map { |item| self.add item }
      end
      
    end
    
  end
  
end