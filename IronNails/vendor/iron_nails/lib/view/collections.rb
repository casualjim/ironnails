module IronNails

  module View
    
    class ViewModelObjectCollection
    
      include Enumerable
      
      def initialize(*items)
        @items = items || []
      end 
      
      def each
        @items.each do |item|
          yield item
        end        
      end
      
      def <<(item)
        @items << item        
      end
      
      def +(*items)
        items.each do |item|
          @items << item
        end
      end
      
      def to_a
        @items
      end
    
    end
    
    class CommandCollection < ViewModelObjectCollection
      
    end
    
    class ModelCollection < ViewModelObjectCollection
      
    end
    
    
  end
  
end