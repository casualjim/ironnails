using System.ComponentModel;

namespace IronNails.Library
{
    public class WpfValue<TValue> : INotifyPropertyChanged
    {

        private TValue _value;

        public TValue Value
        {
            get { return _value; }
            set
            {
                if(_value != null && _value.Equals(value)) return;
                _value = value;
                OnPropertyChanged("Value");
            }
        }

        public WpfValue(TValue value)
        {
            Value = value;
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this,
                          new PropertyChangedEventArgs(propertyName));
            }
        }

    }
}