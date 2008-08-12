
module IronNails
  
  module Models
    
    class Status
      
      def self.timeline_with_friends(credentials, &callback)
        options = { :url => Constants::Urls::FRIENDS_TIMELINE, :credentials => credentials, :root_path => 'statuses/status' }
        internal_request options, &callback        
      end
      
      def self.replies_timeline(credentials, &callback)
        options = { :url => Constants::Urls::REPLIES_TIMELINE, :credentials => credentials, :root_path => 'statuses/status' }
        internal_request options, &callback        
      end 
      
      def self.timeline_for_user(user, credentials, &callback)
        options = { :url => "#{Constants::Urls::USERS_TIMELINE}#{user}#{Constants::RESPONSE_FORMAT}", :credentials => credentials, :root_path => 'statuses/status' }
        internal_request options, &callback 
      end
      
      def self.update_status(message, credentials, &callback)
        request = WebClient.new Constants::Urls::UPDATE_STATUS, credentials
        params = {:status => message, :source => "Sylvester" }
        parse_response = lambda{ |rdr| parse_post_response rdr, message }       
        
        request.post_and_return params, parse_response, &callback        
      end
      
      def self.delete(message, credentials, &callback)
        request = WebClient.new "#{Constants::Urls::DESTROY_TWEET}#{message}#{Constants::RESPONSE_FORMAT}", credentials
        request.get
      end
      
      def self.properties
        %w(created_at id text source truncated in_reply_to_status_id in_reply_to_user_id favorited)
      end
      
      def self.children
        %w(user)
      end
      
      def self.parse_post_response(reader, original_message)
        item = nil 
        IronXml.parse(reader, :stream) do |doc|
          item = self.build_from_post(doc.element('status'), original_message) 
        end
        item
      end
      
      def self.build_from_post(element, original_message)
        return nil if element.nil?
        
        item = self.new      
        item.populate_properties_from(element) do |val|
          if original_message.is_direct_message?
            item.text = original_message
          else
            item.text = HttpUtility.html_decode val
          end
        end
        item.populate_children_from element
        item.is_new = true
        item
      end
      
    end
    
  end
end