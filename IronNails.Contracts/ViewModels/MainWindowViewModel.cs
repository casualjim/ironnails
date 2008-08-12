#region Usings

using System.ComponentModel;
using IronNails.Models;

#endregion

namespace IronNails.ViewModels
{
    public class MainWindowViewModel : INotifyPropertyChanged
    {
        private BindableCollection _directMessages;
        private User _selectedUser;
        private string _statusBarMessage;
        private BindableCollection _statusses;
        private BindableCollection _users;

        /// <summary>
        /// Gets or sets the status bar message.
        /// </summary>
        /// <value>The status bar message.</value>
        public string StatusBarMessage
        {
            get { return _statusBarMessage; }
            set
            {
                if (value == _statusBarMessage) return;
                _statusBarMessage = value;
                OnPropertyChanged("StatusBarMessage");
            }
        }

        /// <summary>
        /// Gets or sets the statusses.
        /// </summary>
        /// <value>The statusses.</value>
        public BindableCollection Statusses
        {
            get { return _statusses; }
            set
            {
                if (value == _statusses) return;
                _statusses = value;
                OnPropertyChanged("Statusses");
            }
        }

        /// <summary>
        /// Gets or sets the direct messages.
        /// </summary>
        /// <value>The direct messages.</value>
        public BindableCollection DirectMessages
        {
            get { return _directMessages; }
            set
            {
                if (value == _directMessages) return;
                _directMessages = value;
                OnPropertyChanged("DirectMessages");
            }
        }

        /// <summary>
        /// Gets or sets the users.
        /// </summary>
        /// <value>The users.</value>
        public BindableCollection Users
        {
            get { return _users; }
            set
            {
                if (value == _users) return;
                _users = value;
                OnPropertyChanged("Users");
            }
        }

        /// <summary>
        /// Gets or sets the selected user.
        /// </summary>
        /// <value>The selected user.</value>
        public User SelectedUser
        {
            get { return _selectedUser; }
            set
            {
                if (value == _selectedUser) return;
                _selectedUser = value;
                OnPropertyChanged("SelectedUser");
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