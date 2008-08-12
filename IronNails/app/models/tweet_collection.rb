module IronNails
  
  module Models
    
    class TweetCollection < BindableCollection
      
      def parish!
        self.each do |item| 
          item.update_humanized_time
          item.is_new = false 
        end
      end
    end
    
  end
  
end