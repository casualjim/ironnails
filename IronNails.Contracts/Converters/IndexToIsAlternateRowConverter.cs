using System;
using System.Globalization;
using System.Windows.Data;

namespace IronNails.Converters
{
    public class IndexToIsAlternateRowConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var index = (int)value;
            return (index % 2 == 1);
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            // Convert back is not used in the binding
            throw new NotImplementedException("The method or operation is not implemented.");
        }
    }
}