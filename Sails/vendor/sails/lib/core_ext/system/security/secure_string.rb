module System
  
  module Security
    
    class SecureString
      
      def to_insecure_string      
        Sails::Security::SecureString.to_insecure_string self
      end  
      
      def encrypt
        Sails::Security::SecureString.encrypt_string self
      end
    end
    
  end
  
end