using System.ComponentModel;

namespace IronNails.Models
{
    public class ModelBase : INotifyPropertyChanged
    {
        private int _index;
        private bool _isNew;

        public ModelBase()
        {
            IsNew = true;
        }

        public bool IsNew
        {
            get { return _isNew; }
            set
            {
                if (value == _isNew) return;
                _isNew = value;
                OnPropertyChanged("IsNew");
            }
        }

        public int Index
        {
            get { return _index; }
            set
            {
                if (value == _index) return;
                _index = value;
                OnPropertyChanged("Index");
            }
        }

        #region INotifyPropertyChanged Members

        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        /// <summary>
        /// Fires the event for the property when it changes.
        /// </summary>
        protected virtual void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}