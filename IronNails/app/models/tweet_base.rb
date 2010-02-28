require File.dirname(__FILE__) + "/tweet_base"

module IronNails

  module Models

    class TweetBase < ModelBase

      attr_accessor :created_at, :humanized_time

      def humanized_time
        update_humanized_time
      end


      def update_humanized_time
        self.humanized_time = self.created_at.humanize if self.created_at
      end

      def self.collection
        TweetCollection
      end

    end

  end
end
