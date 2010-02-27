using System;
using System.Windows;
using System.Windows.Input;

namespace IronNails.Library.Behaviors
{
    internal static class Helpers
    {
        internal static void ExecuteCommand(DependencyObject element, DependencyProperty property)
        {
            Console.WriteLine("Executing command {0}", property.Name);
            var command = (ICommand)element.GetValue(property);
            command.Execute(element);
        }
    }
}