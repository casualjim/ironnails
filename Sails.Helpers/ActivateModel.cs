#region Usings

using System.Windows;

#endregion

namespace Sails.Helpers
{
    public class ActivateModel
    {
        public static readonly DependencyProperty ModelProperty
            = DependencyProperty.RegisterAttached("Model", typeof (DataModel), typeof (ActivateModel),
                                                  new PropertyMetadata(new PropertyChangedCallback(OnModelInvalidated)));

        public static DataModel GetModel(DependencyObject sender)
        {
            return (DataModel) sender.GetValue(ModelProperty);
        }

        public static void SetModel(DependencyObject sender, DataModel model)
        {
            sender.SetValue(ModelProperty, model);
        }

        /// <summary>
        /// Callback when the Model property is set or changed.
        /// </summary>
        private static void OnModelInvalidated(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs e)
        {
            var element = (FrameworkElement) dependencyObject;

            // Add handlers if necessary
            if (e.OldValue == null && e.NewValue != null)
            {
                element.Loaded += OnElementLoaded;
                element.Unloaded += OnElementUnloaded;
            }

            // Or, remove if necessary
            if (e.OldValue != null && e.NewValue == null)
            {
                element.Loaded -= OnElementLoaded;
                element.Unloaded -= OnElementUnloaded;
            }

            // If loaded, deactivate old model and activate new one
            if (!element.IsLoaded) return;
            if (e.OldValue != null)
            {
                ((DataModel) e.OldValue).Deactivate();
            }

            if (e.NewValue != null)
            {
                ((DataModel) e.NewValue).Activate();
            }
        }

        /// <summary>
        /// Activate the model when the element is loaded.
        /// </summary>
        private static void OnElementLoaded(object sender, RoutedEventArgs e)
        {
            var element = (FrameworkElement) sender;
            var model = GetModel(element);
            model.Activate();
        }

        /// <summary>
        /// Deactivate the model when the element is unloaded.
        /// </summary>
        private static void OnElementUnloaded(object sender, RoutedEventArgs e)
        {
            var element = (FrameworkElement) sender;
            var model = GetModel(element);
            model.Deactivate();
        }
    }
}