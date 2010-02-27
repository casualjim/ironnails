module IronNails

  module Models

    class DirectMessage

      @@properties = %w(created_at id text sender_id recipient_id sender_screen_name recipient_screen_name)
      @@children = %w(sender recipient)

      def self.properties
        @@properties
      end

      def self.children
        @@children
      end

      attr_accessor *properties
      attr_accessor *children

      def self.all(credentials, &callback)
        options = { :url => Constants::Urls::DIRECT_MESSAGES, :credentials => credentials, :root_path => 'direct-messages/direct_message' }
        internal_request options, &callback
      end

      def self.sent(credentials, &callback)
        options = { :url => Constants::Urls::SENT_MESSAGES, :credentials => credentials, :root_path => 'direct-messages/direct_message' }
        internal_request options, &callback
      end

      def self.delete(message, credentials, &callback)
        request = WebClient.new "#{Constants::Urls::DESTROY_DIRECT_MESSAGE}#{message}#{Constants::RESPONSE_FORMAT}", credentials
        request.get
      end

      def self.send(user, message, credentials, &callback)
        request = WebClient.new Constants::Urls::UPDATE_STATUS, credentials
        params = { :status => message, :user => user, :source => "Sylvester" }
        request.post_and_return params, nil, &callback
      end

      def to_status
        stat = Status.new
        stat.created_at = self.created_at
        stat.user = self.sender
        stat.text = self.text
        stat.id = self.id

        stat
      end





    end

  end
end