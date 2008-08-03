# This is an implementation of the observer pattern
# It serves to mimic the event system that is known 
# in the CLR world.
# while ruby has a standard observable module that 
# one doesn't allow us to listen for specific events
module Sails::Core

  module Observable
  
    #
    # Add +observer+ as an observer on this object. +observer+ will now receive
    # notifications. +observer+ is interest in the specified +event+
    #
    def add_observer(event, &observer)
      @observers = [] unless defined? @observers
      unless observer.respond_to? :call
        raise NoMethodError, "observer needs to respond to 'update'" 
      end
      @observers << { :event => event, :observer => observer }
    end
    
    #
    # Delete +observer+ as an observer on this object. It will no longer receive
    # notifications of the specified +event+.
    #
    def delete_observer(event, &observer)
      evt = { :event => event, :observer => observer }
      @observers.delete evt if defined? @observers
    end
    
    #
    # Delete all observers associated with this object.
    #
    def delete_observers
      @observers.clear if defined? @observers
    end
    
    #
    # Return the number of observers associated with this object.
    #
    def count_observers
      if defined? @observers
        @observers.size
      else
        0
      end
    end
    
    #
    # Notifies the registered observers that some interesting
    # +event+ has occurred. It will notify the interested parties
    # by calling the block and passing it some context
    #
    def notify_observers(event, sender, *args)
      @observers.select {|evt| evt[:event] == event }.each {|evt| evt[:observer].call sender, *args }
    end
    
  
  end
end