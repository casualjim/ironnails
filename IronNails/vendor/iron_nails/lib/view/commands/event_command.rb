module IronNails
  
  module View
    
    # Encapsulates commands that will be attached to elements in the views.
    class EventCommand < Command
      
      # the name of the event that will trigger the action
      attr_accessor :trigger
      
      # the name of the element that will trigger the action
      attr_accessor :element
      
      # the name of the on which this command needs to be invoked
      attr_accessor :affinity
      
      alias_method :nails_base_command_read_options, :read_options
      def read_options(options)
        nails_base_command_read_options options
        raise ArgumentException.new("An element name is necesary") if options[:element].nil?
        
        @trigger = options[:event]||:click
        @element = options[:element]
        @affinity = options[:affinity]
      end
      
    end
    
  end
  
end