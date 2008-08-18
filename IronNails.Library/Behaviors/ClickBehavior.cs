#region Usings

using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;

#endregion

namespace IronNails.Library.Behaviors
{
    public class ClickBehavior
    {
        public static DependencyProperty DoubleClickCommandProperty =
            DependencyProperty.RegisterAttached("DoubleClick",
                                         typeof(ICommand),
                                         typeof(ClickBehavior),
                                         new FrameworkPropertyMetadata(null, new PropertyChangedCallback(DoubleClickChanged)));

        public static DependencyProperty RightClickCommandProperty = 
            DependencyProperty.RegisterAttached( "RightClick", 
                                                 typeof(ICommand), 
                                                 typeof(ClickBehavior), 
                                                 new FrameworkPropertyMetadata(null,new PropertyChangedCallback(RightClickChanged)));

        public static DependencyProperty LeftClickCommandProperty =
            DependencyProperty.RegisterAttached("LeftClick",
                                                 typeof(ICommand),
                                                 typeof(ClickBehavior),
                                                 new FrameworkPropertyMetadata(null, new PropertyChangedCallback(LeftClickChanged)));

        public static void SetLeftClick(DependencyObject target, ICommand value)
        {
            target.SetValue(LeftClickCommandProperty, value);
        }

        private static void LeftClickChanged(DependencyObject target, DependencyPropertyChangedEventArgs e)
        {
            var element = target as UIElement;

            if (element == null) return;
            // If we're putting in a new command and there wasn't one already
            // hook the event
            if ((e.NewValue != null) && (e.OldValue == null))
            {
                if(target is ButtonBase)
                    ((ButtonBase)target).Click += ClickBehavior_Click;
                else
                    element.MouseLeftButtonUp += element_MouseLeftButtonUp;
            }
            // If we're clearing the command and it wasn't already null
            // unhook the event
            else if ((e.NewValue == null) && (e.OldValue != null))
            {
                element.MouseLeftButtonUp -= element_MouseLeftButtonUp;
            }
        }

        static void ClickBehavior_Click(object sender, RoutedEventArgs e)
        {
           Helpers.ExecuteCommand((UIElement)sender, LeftClickCommandProperty);
        }

        private static void element_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            if(DoubleClickCommandProperty == null || e.ClickCount == 1)
                Helpers.ExecuteCommand((UIElement)sender, LeftClickCommandProperty);
        }
        
        public static void SetDoubleClick(DependencyObject target, ICommand value)
        {
            target.SetValue(DoubleClickCommandProperty, value);
        }

        private static void DoubleClickChanged(DependencyObject target, DependencyPropertyChangedEventArgs e)
        {
            var element = target as UIElement;

            if (element == null) return;
            // If we're putting in a new command and there wasn't one already
            // hook the event
            if ((e.NewValue != null) && (e.OldValue == null))
            {
                if (target is Control)
                    ((Control)target).MouseDoubleClick += ClickBehavior_MouseDoubleClick;
                else
                    element.MouseLeftButtonUp += element_MouseDoubleButtonUp;
            }
            // If we're clearing the command and it wasn't already null
            // unhook the event
            else if ((e.NewValue == null) && (e.OldValue != null))
            {
                if (target is Control)
                    ((Control) target).MouseDoubleClick -= ClickBehavior_MouseDoubleClick;
                else 
                    element.MouseLeftButtonUp -= element_MouseDoubleButtonUp;
            }
        }

        static void ClickBehavior_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            throw new NotImplementedException();
        }

        private static void element_MouseDoubleButtonUp(object sender, MouseButtonEventArgs e)
        {
            if(e.ClickCount > 1)
                Helpers.ExecuteCommand((UIElement)sender, DoubleClickCommandProperty);
        }


        public static void SetRightClick(DependencyObject target, ICommand value)
        {
            target.SetValue(RightClickCommandProperty, value);
        }


        private static void RightClickChanged(DependencyObject target, DependencyPropertyChangedEventArgs e)
        {
            var element = target as UIElement;

            if (element == null) return;
            // If we're putting in a new command and there wasn't one already
            // hook the event
            if ((e.NewValue != null) && (e.OldValue == null))
            {
                element.MouseRightButtonUp += element_MouseRightButtonUp;
            }
            // If we're clearing the command and it wasn't already null
            // unhook the event
            else if ((e.NewValue == null) && (e.OldValue != null))
            {
                element.MouseRightButtonUp -= element_MouseRightButtonUp;
            }
        }


        private static void element_MouseRightButtonUp(object sender, MouseButtonEventArgs e)
        {
            Helpers.ExecuteCommand((UIElement)sender, RightClickCommandProperty);
        }

        
    }
}