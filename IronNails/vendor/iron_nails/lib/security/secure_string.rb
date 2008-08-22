module IronNails
  
  module Security
    
    # this doesn't work yet. There is a C# alternative IronNails::Library::SecureString
    class SecureString
      
      ENCRYPTION_SALT = "SailsPasswordSalt"
      
      
      @@entropy = StaticTypingHelper.get_unicode_bytes("SailsPasswordSalt")
      
      class << self
        include System::Security::Cryptography
        include System::Runtime::InteropServices
      
        def encrypt_string(input)
          encrypted_data = ProtectedData.protect(
            StaticTypingHelper.get_unicode_bytes(unsecure_string(input)),
            @@entropy,
            DataProtectionScope.current_user)
          StaticTypingHelper.convert_to_base64_string(encrypted_data)
        end 
        
        def secure_string(input)
          secure = System::Security::SecureString.new 
          input.each {|c| secure.append_char c.to_clr_char }
          secure.make_read_only
          secure
        end  
        
        def unsecure_string(input)
          result = ""
          ptr = System::Runtime::InteropServices::Marshal.SecureStringToBSTR(input);
          begin
            result = System::Runtime::InteropServices::Marshal.PtrToStringBSTR(ptr);
          ensure
            System::Runtime::InteropServices::Marshal.ZeroFreeBSTR(ptr);
          end
          result
        end  
        
        def decrypt_string(encrypted_data)
          begin
            decrypted_data = ProtectedData.unprotect(
              Convert.from_base64_string(encrypted_data),
              @@entropy,
              DataProtectionScope.current_user);
            secure_string(StaticTypingHelper.get_unicode_bytes(decrypted_data));
          rescue
            System::Security::SecureString.new
          end
        end 
      
      end
      
    end
    
  end
  
end