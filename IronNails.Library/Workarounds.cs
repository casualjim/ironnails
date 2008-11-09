using System;
using System.Windows;
using System.Windows.Threading;

namespace IronNails.Helpers
{

    public class Workarounds
    {
        public static readonly Action EmptyDelegate = () => { };

        public static void Refresh(UIElement target)
        {
            target.Dispatcher.Invoke(DispatcherPriority.Render, EmptyDelegate);
        }

        //IronRuby doesn't know how to deal with an indexer on a resource dictionary
        public static object GetResource(ResourceDictionary dictionary, string key)
        {
            return dictionary[key];
        }

        public static object GetAppResource(string key)
        {
            return Application.Current.Resources[key];
        }
    }
}