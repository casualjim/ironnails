using System;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Windows;
using System.Linq;

namespace IronNails
{
    public static class ExtensionMethods
    {
        public static bool IsEmpty(this string text)
        {
            return string.IsNullOrEmpty(text) || text.Trim().Length == 0;
        }

        public static bool IsUrl(this string text)
        {
            return Uri.IsWellFormedUriString(text, UriKind.Absolute) && new[] { "http", "https", "ftp" }.Contains(new Uri(text).Scheme);
        }

        public static bool IsAtName(this string text)
        {
            return text.StartsWith("@");
        }

        public static void TryOpeningUrl(this Uri uri)
        {
            try
            {
                Process.Start(uri.ToString());
            }
            catch
            {
                //TODO: Log specific URL that caused error
                MessageBox.Show("There was a problem launching the specified URL.", "Error", MessageBoxButton.OK,
                                MessageBoxImage.Exclamation);
            }
        }


        public static string CaptureUrlIfAny(this string text)
        {
            if (text.IsEmpty()) return string.Empty;

            var match = Regex.Match(text, "href=\"((f|h)ttps?://.+)\"", RegexOptions.IgnoreCase);
            return match.Success ? match.Groups[1].Value : string.Empty;
        }

    }
}