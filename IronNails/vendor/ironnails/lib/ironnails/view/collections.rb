module IronNails

  module Core

    class Collection

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

  end

  module View

    class CommandCollection < Core::Collection

      def has_command?(command)
        !self.find do |cmd|
          command == cmd
        end.nil?
      end

    end

    class ViewCollection < Core::Collection

      def has_view?(view)
        find_view(view[:name]).nil?
      end

      def find_view(name)
        self.find { |vw| vw[:name] == name }
      end

    end

    class ViewModelCollection < Core::Collection

      def has_viewmodel?(view_model)
        if view_model.is_a?(String)
          find_viewmodel(view_model).nil?
        else
          find_viewmodel(view_model.__view_model_name_).nil?
        end
      end

      def find_viewmodel(name)
        self.find { |vm| vm.__view_model_name_ == name }
      end

      def <<(model)
        @items << model unless has_viewmodel?(model)
        find_viewmodel(model.__view_model_name_)
      end

    end

    class ModelCollection < Core::Collection

      def has_model?(model)
        !get_model(model).nil?
      end

      def add_model(model)
        key = model.keys[0]
        has_model?(model) ? get_model(model)[key] = model[key] : @items << model
      end

      def get_model(model)
        @items.find do |m|
          model.keys[0] == m.keys[0]
        end
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