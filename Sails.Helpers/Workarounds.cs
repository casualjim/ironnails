using System.Windows;

namespace Sails.Helpers
{
    public class Workarounds
    {
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