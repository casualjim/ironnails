module IronNails

  module Models

    class BindableCollection < System::Collections::ObjectModel::ObservableCollection.of(System::Object)

      def initialize(*list)
        list.map { |item| self.add item }
      end

    end

  end

end