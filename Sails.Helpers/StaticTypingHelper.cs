#region Usings

using System;
using System.Text;

#endregion

namespace Sails.Helpers
{
    /// <summary>
    /// This class contains methods to work around some shortcomings 
    /// that exist in IronRuby today. Hopefully these things can be replaced
    /// as development progresses.
    /// </summary>
    public class StaticTypingHelper
    {
        public static byte[] GetUnicodeBytes(string input)
        {
            return Encoding.Unicode.GetBytes(input);
        }

        public static string GetUnicodeString(byte[] input)
        {
            return Encoding.Unicode.GetString(input);
        }

        public static string ConvertToBase64String(byte[] input)
        {
            return Convert.ToBase64String(input);
        }
    }
}