module IronNails
  
  module Models
    
    class ModelBase     
      
      include IronNails::Core::FeedParser
      extend IronNails::Core::FeedParser::ClassMethods
      
      def initialize
        yield if block_given?
      end
      
      def ==(other)
        !!other && self.id == other.id
      end
      alias_method :equals, :==     
      
    end
    
  end
  
end