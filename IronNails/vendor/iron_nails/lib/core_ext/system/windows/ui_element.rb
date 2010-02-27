module System

  module Windows

    class UIElement

      @@empty_delegate = System::Action.new { }
      @@empty_priorty = System::Windows::Threading::DispatcherPriority.render

      def refresh
        self.dispatcher.invoke @@empty_priorty, @@empty_delegate
      end
    end

  end

end