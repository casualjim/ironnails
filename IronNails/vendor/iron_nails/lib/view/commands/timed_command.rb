module IronNails

  module View

    class TimedCommand < Command

      # gets the name to use for the timer     
      attr_reader :timer_name

      attr_accessor :interval

      alias_method :nails_base_command_read_options, :read_options

      def read_options(options)
        nails_base_command_read_options options

        @timer_name = get_timer_name
      end

      # This stops the timer in the view proxy
      def stop_timer
        view.stop_timer self
      end

      # This starts the timer in the view proxy
      def start_timer
        view.start_timer self
      end

      private

      def get_timer_name
        "__#{name}_ironnails_view_timer"
      end

    end

  end

end