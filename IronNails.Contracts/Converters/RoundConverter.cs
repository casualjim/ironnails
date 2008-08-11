using System;
using System.Globalization;
using System.Windows.Data;

namespace IronNails.Converters
{
    public class RoundConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var inputValue = Math.Round(Double.Parse(value.ToString()));
            return inputValue;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            try
            {
                var inputValue = Math.Round(Double.Parse(value.ToString()));
                return inputValue;
            }
            catch
            {
                return 0;
            }
        }
    }
}