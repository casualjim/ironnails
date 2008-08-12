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
            
      def to_a
        @items
      end
    
    end
    
    class CommandCollection < ViewModelObjectCollection
    
      class << self
        
        # Given a set of +command_definitions+ it will generate
        # a collection of Command objects for the view model
        def generate_for(command_definitions, view_model)
          commands = new
          command_definitions.each do |cmd_def|
            cmd = Command.new(cmd_def.merge({ :view_model => view_model }))
            commands << cmd
          end
          commands
        end 
        
      end
      
    end
    
    class ModelCollection < ViewModelObjectCollection
      
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