module IronNails
  
  module Models
    
    class ModelBase

      include IronNails::Models::ModelMixin
      include IronNails::Models::Databinding
      include IronNails::Core::FeedParser
      extend IronNails::Core::FeedParser::ClassMethods


      attr_accessor :index, :is_new

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