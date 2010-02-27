module System

  module Security

    class SecureString

      def to_insecure_string
        IronNails::Security::SecureString.to_insecure_string self
      end

      def encrypt
        IronNails::Security::SecureString.encrypt_string self
      end
    end

  end

end