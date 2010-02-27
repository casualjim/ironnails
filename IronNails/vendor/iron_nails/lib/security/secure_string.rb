module IronNails

  module Security

    class SecureString

      ENCRYPTION_SALT = "SailsPasswordSalt".freeze



      @@entropy = System::Text::Encoding.unicode.get_bytes(ENCRYPTION_SALT)

      class << self
        include System::Security::Cryptography
        include System::Runtime::InteropServices

        def encrypt_string(input)
          encrypted_data = ProtectedData.protect(
                  System::Text::Encoding.unicode.get_bytes(unsecure_string(input)),
                  @@entropy,
                  DataProtectionScope.current_user)
          System::Convert.to_base64_string(encrypted_data)
        end

        def secure_string(input)
          secure = System::Security::SecureString.new
          input.to_s.to_clr_string.to_char_array.each {|c| secure.append_char c }
          secure.make_read_only
          secure
        end

        def unsecure_string(input)
          #return input.to_s unless input.is_a? System::Security::SecureString
          result = ""
          ptr = System::Runtime::InteropServices::Marshal.SecureStringToBSTR(input);
          begin
            result = System::Runtime::InteropServices::Marshal.PtrToStringBSTR(ptr);
          ensure
            System::Runtime::InteropServices::Marshal.ZeroFreeBSTR(ptr);
          end
          result.to_s
        end

        def decrypt_string(encrypted_data)
          begin
            decrypted_data = ProtectedData.unprotect(
                    Convert.from_base64_string(encrypted_data),
                    @@entropy,
                    DataProtectionScope.current_user);
            secure_string(System::Text::Encoding.unicode.get_bytes(decrypted_data));
          rescue
            System::Security::SecureString.new
          end
        end

      end

    end

  end

end