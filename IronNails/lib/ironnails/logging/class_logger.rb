module IronNails

  module Logging

    module ClassLogger

      # provides access for the logger we are using
      # you can override this logger as long as it responds to
      # the methods: debug, info, warn, error, fatal
      def logger
        IRONNAILS_DEFAULT_LOGGER
      end

      # Ensures that a message is logged when the execution of 
      # the specified block throws an error. It will then re-raise the error.
      def log_on_error
        begin
          yield if block_given?
        rescue Exception => e
          logger.error "IronNails Error: #{e}"
          raise e
        end
      end

    end

  end

end