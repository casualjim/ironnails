module IronNails

  module View
    
    class ViewModelObjectCollection
    
      include Enumerable
      
      def initialize(*items)
        @items = items || []
      end 
      
      def each
        @items.each do |item|
          yield item
        end        
      end
      
      def <<(item)
        @items << item        
      end
      
      def [](value)
        @items[value]
      end
            
      def to_a
        @items
      end
    
    end
    
    class CommandCollection < ViewModelObjectCollection
    
      def has_command?(command)
         !self.find do |cmd|
           command == cmd
         end.nil?
      end
              
      
      class << self
        
        # Given a set of +command_definitions+ it will generate
        # a collection of Command objects for the view model
        def generate_for(command_definitions, view_model)
          commands = new
          command_definitions.each do |name, cmd_def|
            cmd = Command.create_from(cmd_def.merge({ :view_model => view_model, :name => name }))
            commands << cmd
          end if command_definitions.is_a?(Hash)
          #commands << Command.new(command_definitions.merge({ :view_model => view_model })) if command_definitions.is_a?(Hash)
          commands
        end 
        
        
      end
      
    end
    
    class ModelCollection < ViewModelObjectCollection
    
      def has_model?(model)
        !self.find do |m|
          model.keys[0] == m.keys[0]
        end.nil?
      end
      
      class << self
        
        # Given a set of +objects+ it will generate
        # a collection of objects for the view model
        def generate_for(objects)
          models = new
          objects.each do |k, v|
            models << { k => v } 
          end
          models
        end 
      
      end
      
    end
    
    
  end
  
end