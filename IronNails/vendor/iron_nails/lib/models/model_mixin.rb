module IronNails

  module Models

    module ModelMixin

      include IronNails::Logging::ClassLogger      

    end

    module Databinding

      module ClassMethods

        # defines a write-only attribute on an object
        # this would map to a property setter in different languages
        def attr_writer(*names)
          names.each do |nm|
            mn = nm
            self.send :define_method, "#{nm}=".to_sym do |arg|
              __vr__ =  instance_variable_get :"@#{mn}"
              return __vr__ if __vr__ == arg
              instance_variable_set :"@#{mn}", arg
              raise_property_changed mn
            end
          end
        end

        # defines a read/write attribute on an object.
        # this would map to a property with a getter and a setter in different langauages
        def attr_accessor(*names)
          attr_reader *names
          attr_writer *names
        end


      end

      # extend the class with the class methods defined in this module
      def self.included(base)
        base.send :include, System::ComponentModel::INotifyPropertyChanged unless base.ancestors.include? System::ComponentModel::INotifyPropertyChanged
        base.extend ClassMethods
      end

      def add_PropertyChanged(handler=nil)
        @__handlers__ ||= []
        @__handlers__ << handler
      end

      def remove_PropertyChanged(handler=nil)
        @__handlers__ ||= []
        @__handlers__.delete handler
      end

      private
      def raise_property_changed(name)
        return unless @__handlers__
        @__handlers__.each do |ev|
          ev.invoke self, System::ComponentModel::PropertyChangedEventArgs.new(name) if ev.respond_to? :invoke
          ev.call self, System::ComponentModel::PropertyChangedEventArgs.new(name) if ev.respond_to? :call
        end
      end

    end


  end

end