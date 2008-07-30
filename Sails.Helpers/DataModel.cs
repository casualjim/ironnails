#region Usings

using System.ComponentModel;
using System.Windows.Threading;

#endregion

namespace Sails.Helpers
{
    /// <summary>
    /// Provides a base class for implementing models that encapsulate
    /// data and behavior that is independent of the presentation.
    /// </summary>
    public abstract class DataModel : INotifyPropertyChanged
    {
        #region ModelState enum

        /// <summary>
        /// Possible states for a DataModel.
        /// </summary>
        public enum ModelState
        {
            Invalid, // The model is in an invalid state
            Fetching, // The model is being fetched
            Valid // The model has fetched its data
        }

        #endregion

        private readonly Dispatcher _dispatcher;
        private bool _isActive;
        private PropertyChangedEventHandler _propertyChangedEvent;
        private ModelState _state;


        /// <summary>
        /// Initializes an instance of a DataModel.
        /// </summary>
        protected DataModel()
        {
            _dispatcher = Dispatcher.CurrentDispatcher;
            State = ModelState.Invalid;
        }

        /// <summary>
        /// Is the model active?
        /// </summary>
        public bool IsActive
        {
            get
            {
                return _isActive;
            }

            private set
            {
                if (value == _isActive) return;
                _isActive = value;
                OnPropertyChanged("IsActive");
            }
        }

        /// <summary>
        /// Gets or sets current state of the model.
        /// </summary>
        public ModelState State
        {
            get
            {
                return _state;
            }

            set
            {
                if (value == _state) return;
                _state = value;
                OnPropertyChanged("State");
            }
        }

        /// <summary>
        /// The Dispatcher associated with the model.
        /// </summary>
        public Dispatcher Dispatcher
        {
            get { return _dispatcher; }
        }

        #region INotifyPropertyChanged Members

        /// <summary>
        /// PropertyChanged event for INotifyPropertyChanged implementation.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged
        {
            add
            {
                _propertyChangedEvent += value;
            }
            remove
            {
                _propertyChangedEvent -= value;
            }
        }

        #endregion

        /// <summary>
        /// Activate the model.
        /// </summary>
        public void Activate()
        {
            if (_isActive) return;
            IsActive = true;
            OnActivated();
        }

        /// <summary>
        /// Override to provide behavior on activate.
        /// </summary>
        protected virtual void OnActivated()
        {
        }

        /// <summary>
        /// Deactivate the model.
        /// </summary>
        public void Deactivate()
        {
            if (!_isActive) return;
            IsActive = false;
            OnDeactivated();
        }

        /// <summary>
        /// Override to provide behavior on deactivate.
        /// </summary>
        protected virtual void OnDeactivated()
        {
        }

        /// <summary>
        /// Utility function for use by subclasses to notify that a property has changed.
        /// </summary>
        /// <param name="propertyName">The name of the property.</param>
        protected void OnPropertyChanged(string propertyName)
        {
            if (_propertyChangedEvent != null)
            {
                _propertyChangedEvent(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}