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
                _value = value;
                OnPropertyChanged("Value");
            }
        }

        public WpfValue(TValue value)
        {
            Value = value;
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged(string strPropertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this,
                          new PropertyChangedEventArgs(strPropertyName));
            }
        }

    }
}