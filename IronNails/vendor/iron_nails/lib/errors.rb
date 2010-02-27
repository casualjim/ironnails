module IronNails

  module Errors

    class IronNailsError < StandardError


    end

    class ContractError < IronNails::Errors::IronNailsError

      def initialize(method)
        super "#{method} needs to be overridden in an implementing class"
      end

    end

  end
end