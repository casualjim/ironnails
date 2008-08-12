module IronNails

  module View
  
    # Encapsulates commands that will be attached to the views.
    class Command
    
      include IronNails::Logging::ClassLogger
    
      # the name of the event that will trigger the action
      attr_accessor :trigger
      
      # the name of the element that will trigger the action
      attr_accessor :element
      
      # the action that will be triggered 
      attr_accessor :action
      
      # the view this command is bound to
      attr_accessor :view
      
      attr_reader :view_model
      
      def initialize(options)
        raise ArgumentException.new("An element name is necesary") if options[:element].nil?
        raise ArgumentException.new("An action is necesary") if options[:action].nil?
        
        @trigger = options[:event]||:click
        @element = options[:element]
        @action = options[:action]
        @view_model = options[:view_model]
      end 
      
#      # Attaches this command to the specified +view+
#      def attach_to(view)
#        @view = view
#        view.send(element.to_sym).send(trigger.to_sym) { execute }
#      end
      
      # executes this command (it calls the action)
      def execute
        log_on_error do
          # FIXME: arity hasn't been implemented on Proc yet.
          #        So for now when we're dealing with a Proc we'll first try to call
          #        the method without a parameter and next the method with a parameter
          #        In other words below is a grotesque hack
          if @action.is_a?(Method) && @action.arity > 0
            @action.call view
          else 
            begin
              if @action.is_a?(Proc)
                @action.call view 
              else
                @action.call
              end
            rescue ArgumentError => ae
              if @action.is_a?(Proc)
                @action.call 
              else
                raise ae
              end
            end
          end
          view_model.configure_view
        end
      end
      
      
    
    end
  
  end

end