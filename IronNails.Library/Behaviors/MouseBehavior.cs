using System;
using System.Windows;
using System.Windows.Input;
using IronNails.Library.Behaviors;

namespace IronNails.Library.Behaviors
{
    public class MouseHoverBehavior 
    {
        #region MouseEnter
        public static DependencyProperty MouseEnterCommandProperty =
            DependencyProperty.RegisterAttached("MouseEnter",
                                                 typeof(ICommand),
                                                 typeof(MouseHoverBehavior),
                                                 new FrameworkPropertyMetadata(null, new PropertyChangedCallback(MouseEnterChanged)));

        public static void SetMouseEnter(DependencyObject target, ICommand value)
        {
            target.SetValue(MouseEnterCommandProperty, value);
        }

        private static void MouseEnterChanged(DependencyObject target, DependencyPropertyChangedEventArgs e)
        {
            var element = target as UIElement;

            if (element == null) return;
            // If we're putting in a new command and there wasn't one already
            // hook the event
            if ((e.NewValue != null) && (e.OldValue == null))
            {
                element.MouseEnter += element_MouseEnter;
            }
            // If we're clearing the command and it wasn't already null
            // unhook the event
            else if ((e.NewValue == null) && (e.OldValue != null))
            {
                element.MouseEnter -= element_MouseEnter;
            }
        }

        private static void element_MouseEnter(object sender, MouseEventArgs e)
        {
            Helpers.ExecuteCommand((UIElement)sender, MouseEnterCommandProperty);
        } 
        #endregion

        #region MouseLeave
        public static DependencyProperty MouseLeaveCommandProperty =
            DependencyProperty.RegisterAttached("MouseLeave",
                                                 typeof(ICommand),
                                                 typeof(MouseHoverBehavior),
                                                 new FrameworkPropertyMetadata(null, new PropertyChangedCallback(MouseLeaveChanged)));

        public static void SetMouseLeave(DependencyObject target, ICommand value)
        {
            target.SetValue(MouseLeaveCommandProperty, value);
        }

        private static void MouseLeaveChanged(DependencyObject target, DependencyPropertyChangedEventArgs e)
        {
            var element = target as UIElement;

            if (element == null) return;
            // If we're putting in a new command and there wasn't one already
            // hook the event
            if ((e.NewValue != null) && (e.OldValue == null))
            {
                element.MouseLeave += element_MouseLeave;
            }
            // If we're clearing the command and it wasn't already null
            // unhook the event
            else if ((e.NewValue == null) && (e.OldValue != null))
            {
                element.MouseLeave -= element_MouseLeave;
            }
        }

        private static void element_MouseLeave(object sender, MouseEventArgs e)
        {
            Helpers.ExecuteCommand((UIElement)sender, MouseLeaveCommandProperty);
        } 
        #endregion
    }
}