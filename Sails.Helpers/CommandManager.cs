#region Usings

using System.Windows;
using System.Windows.Input;

#endregion

namespace Sails.Helpers
{
    /// <summary>
    /// Attached property that can be used to create a binding for a CommandModel. Set the
    /// CreateCommandBinding.Command property to a CommandModel.
    /// </summary>
    public static class CommandManager
    {
        public static readonly DependencyProperty CommandProperty
            = DependencyProperty.RegisterAttached("Command", typeof (CommandModel), typeof (CommandManager),
                                                  new PropertyMetadata(new PropertyChangedCallback(OnCommandInvalidated)));

        public static CommandModel GetCommand(DependencyObject sender)
        {
            return (CommandModel) sender.GetValue(CommandProperty);
        }

        public static void SetCommand(DependencyObject sender, CommandModel command)
        {
            sender.SetValue(CommandProperty, command);
        }

        /// <summary>
        /// Callback when the Command property is set or changed.
        /// </summary>
        private static void OnCommandInvalidated(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs e)
        {
            // Clear the exisiting bindings on the element we are attached to.
            var element = (UIElement) dependencyObject;
            element.CommandBindings.Clear();

            // If we're given a command model, set up a binding
            var commandModel = e.NewValue as CommandModel;
            if (commandModel != null)
            {
                element.CommandBindings.Add(new CommandBinding(commandModel.Command, commandModel.OnExecute,
                                                               commandModel.OnQueryEnabled));
            }

            // Suggest to WPF to refresh commands
            System.Windows.Input.CommandManager.InvalidateRequerySuggested();
        }
    }
}