module IronNails
  module Core
    module Constants
      RESPONSE_FORMAT = ".xml" unless defined? RESPONSE_FORMAT
      CHARACTER_LIMIT = 140 unless defined? CHARACTER_LIMIT
      
      module Urls        
        VERIFY_CREDENTIALS = "http://twitter.com/account/verify_credentials.xml" unless defined? VERIFY_CREDENTIALS
        PROFILE = "http://twitter.com/users/show/" unless defined? PROFILE
        FOLLOWERS = "http://twitter.com/statuses/followers.xml" unless defined? FOLLOWERS
        FRIENDS = "http://twitter.com/statuses/friends.xml" unless defined? FRIENDS
        FRIENDS_TIMELINE = "http://twitter.com/statuses/friends_timeline.xml" unless defined? FRIENDS_TIMELINE
        USERS_TIMELINE = "http://twitter.com/statuses/user_timeline/" unless defined? USERS_TIMELINE
        DIRECT_MESSAGES = "http://twitter.com/direct_messages.xml" unless defined? DIRECT_MESSAGES
        REPLIES_TIMELINE = "http://twitter.com/statuses/replies.xml" unless defined? REPLIES_TIMELINE
        SENT_MESSAGES = "http://twitter.com/direct_messages/sent.xml" unless defined? SENT_MESSAGES
        UPDATE_STATUS = "http://twitter.com/statuses/update.xml" unless defined? TWEETS
        FRIENDS_PROFILE = "http://twitter.com/users/show/" unless defined? FRIENDS_PROFILE
        USER = "http://twitter.com/" unless defined? USER      
        DESTROY_TWEET = "http://twitter.com/statuses/destroy/" unless defined? DESTROY_TWEET
        DESTROY_DIRECT_MESSAGE = "http://twitter.com/direct_messages/destroy/" unless defined? DESTROY_DIRECT_MESSAGE   
        FOLLOW_USER = "http://twitter.com/friendships/create/" unless defined? FOLLOW_USER            
      end
      
      module RequestMethods
        GET = "GET" unless defined? GET
        POST = "POST" unless defined? POST
      end
      
      module DateFormats
        CREATED_AT_FORMAT = "ddd MMM dd HH:mm:ss zzzz yyyy" unless defined? CREATED_AT_FORMAT
        SINCE_FORMAT = "ddd MMM dd yyyy HH:mm:ss zzzz" unless defined? SINCE_FORMAT
      end
    end
  end
end
