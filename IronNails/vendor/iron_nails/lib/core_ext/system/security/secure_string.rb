module System
  
  module Security
    
    class SecureString
      
      def to_insecure_string      
        IronNails::Library::SecureString.to_insecure_string self
      end  
      
      def encrypt
        IronNails::Library::SecureString.encrypt_string self
      end
    end
    
  end
  
end