module IronNails
  
  module Models
    
    class Credentials
      
      attr_accessor :username, :password, :authenticated
      
      def initialize(username, password)
        @authenticated = false;
        @username = username
        @password = password
      end
      
      # validates the credentials against twitter
      # also prepares the cache to use with authenticated?
      def validate
        @authenticated = false
        
        begin
          @authenticated = WebClient.new(Constants::Urls::VERIFY_CREDENTIALS, self).post_and_return
        rescue SecurityException => e
          @authenticated = false
        end
        
        @authenticated
      end
      
      # returns the cached version of +validate+
      # if the credentials were invalid or haven't been 
      # authenticated yet it will authenticate
      def are_valid?
        @authenticated ? @authenticated : validate
      end
      
      def to_network_credentials
        NetworkCredential.new username, password.to_insecure_string
      end
      
    end
    
  end
end