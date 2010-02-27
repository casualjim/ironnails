module IronNails

  module View

    class AddSubViewCommand < Command

      # the controller for the subview
      attr_accessor :controller

      # the target that will contain the view for this controller
      attr_accessor :target

      alias_method :nails_base_command_read_options, :read_options

      def read_options(options)
        nails_base_command_read_options options
        raise ArgumentError.new("We need a target to be defined by the :to parameter") if options[:to].nil?
        raise ArgumentError.new("We need a controller instance to be defined in the :controller parameter") if options[:controller].nil? || !options[:controller].respond_to?(:current_view)

        @controller = options[:controller]
        @target = options[:to]
      end

      # executes this command (it calls the action)
      def execute
        view.add_control target, controller.current_view.instance
      end

    end

  end

end