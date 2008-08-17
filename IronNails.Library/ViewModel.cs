using System.ComponentModel;
using IronNails.Library;
using IronNails.Models;

namespace IronNails.View
{
    /// <summary>
    /// This is our strongly type wrapper around 2 dictionaries
    /// These dictionaries are being used for databinding in the 
    /// xaml views
    /// </summary>
    public class ViewModel : INotifyPropertyChanged
    {

        private ObservableDictionary<string, object> _objects;
        private ObservableDictionary<string, DelegateCommand> _commands;

        public void InitializeDictionaries()
        {
            _objects = new ObservableDictionary<string, object>();
            _commands = new ObservableDictionary<string, DelegateCommand>();
        }

        /// <summary>
        /// Gets or sets the objects.
        /// </summary>
        /// <value>The objects.</value>
        public ObservableDictionary<string, object> Objects
        {
            get { return _objects; }
            set
            {
                if (value == _objects) return;
                _objects = value;
                OnPropertyChanged("Objects");
            }
        }

        public ObservableDictionary<string, DelegateCommand> Commands
        {
            get { return _commands; }
            set
            {
                if (value == _commands) return;
                _commands = value;
                OnPropertyChanged("Commands");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

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