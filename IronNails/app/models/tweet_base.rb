module IronNails
  
  module Models
    
    class TweetBase
      
      def update_humanized_time
        self.humanized_time = self.created_at.humanize unless created_at.nil?
      end  
      
      def self.collection
        TweetCollection        
      end
      
    end
    
  end
end