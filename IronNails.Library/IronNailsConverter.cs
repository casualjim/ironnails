using System;
using System.Globalization;
using System.Windows.Data;
using System.Windows.Markup;

namespace IronNails.Library
{
    public class IronNailsConverterExtension : MarkupExtension
    {
        public string ConverterName { get; set; }

        public override object ProvideValue(IServiceProvider serviceProvider)
        {
            return new IronNailsConverter {ConverterName = ConverterName};
        }
    }

    public class IronNailsConverter : IValueConverter
    {
        private const string Forward = "convert";
        private const string Back = "convert_back";
        private const string Suffix = "_converter";
        private object _converter;
        private DlrHelper _helper;
        public string ConverterName { get; set; }

        #region IValueConverter Members

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            EnsureConverter();

            var res =  _helper.CallMethod(_converter, Forward, value, targetType, parameter, culture);
            return res;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            EnsureConverter();

            return _helper.CallMethod(_converter, Back, value, targetType, parameter, culture);
        }

        #endregion

        private void EnsureConverter()
        {
            if (_helper.IsNull()) _helper = new DlrHelper();
            if (_converter.IsNull())
                _converter = _helper.LoadObject(ConverterName + Suffix);
        }
    }
}