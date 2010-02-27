module IronNails

  module View

    # The base class for view models in an IronNails application.
    module ViewModelMixin

      include IronNails::Logging::ClassLogger

      def __view_model_name_
        self.class.demodulize.underscore
      end

      # adds a model for the view in the dictionary
      def add_model(k, v)
        unless self.respond_to?(k) && self.respond_to?(:"#{k}=")
          logger.debug "adding object to the view model #{k}", IRONNAILS_FRAMEWORKNAME
          self.class.attr_accessor k
        end
        self.send :"#{k}=", v if self.send(k) != v
      end

      alias_method :set_model, :add_model

      # configures a command appropriately on the view.
      # for an EventCommand it will pass it to the view and the view will attach the
      # appropriate events
      # for a TimedCommand it will create a timer in the view proxy object
      # for a BehaviorCommand it will add the appropriate delegate command to the 
      # Commands dictionary on the ViewModel class
      def add_command(cmd)
        dc = cmd.to_clr_command
        cmd_name = cmd.name.to_s
        unless self.respond_to?(cmd_name.to_sym) && self.respond_to?(:"#{cmd_name}=")
          logger.debug "adding command to the view model #{cmd_name}", IRONNAILS_FRAMEWORKNAME
          self.class.attr_accessor cmd_name.to_sym
        end
        self.send :"#{cmd_name}=", dc
      end

    end

  end

end