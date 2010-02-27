module IronNails

  module Models

    class User < ModelBase

      def self.properties
        %w(id name screen_name location description
        profile_image_url url protected followers_count)
      end

      attr_accessor *properties
      attr_accessor :created_at, :favourites_count, :following, :friends_count
      attr_accessor :statuses_count, :time_zone, :utc_offset, :status

      attr_reader :twitter_url, :full_name

      def twitter_url
        "http://twitter.com/#{screen_name}"
      end

      def full_name
        "#{name} (#{screen_name})"
      end

      def self.friends(credentials, &callback)
        options = { :url => Constants::Urls::FRIENDS, :credentials => credentials, :root_path => 'users/user' }
        internal_request options, &callback
      end

      def self.followers(credentials, &callback)
        options = { :url => Constants::Urls::FOLLOWERS, :credentials => credentials, :root_path => 'users/user'}
        internal_request options, &callback
      end

      def self.follow(user, credentials, &callback)
        wc = WebClient.new "Constants::Urls::FOLLOWERS#{user}#{Constants::RESPONSE_FORMAT}", credentials
        wc.get &callback
      end

      def self.login(credentials, &callback)
        url = "#{Constants::Urls::FRIENDS_PROFILE}#{credentials.username}#{Constants::RESPONSE_FORMAT}"
        options = { :url => url, :entity => true, :credentials => credentials}
        user = internal_request options, &callback
        user
        #new
      end


      def self.children
        %w(status)
      end

    end

  end
end