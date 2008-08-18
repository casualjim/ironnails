using System.Windows;
using System.Windows.Input;
using IronNails.Library;
using IronNails.View;

namespace IronNails.Experiments
{
    public class WindowViewModel : ViewModel
    {
        private ICommand _showMessage;

        public ICommand ShowMessage
        {
            get
            {
                if (_showMessage == null)
                    _showMessage = new DelegateCommand(() => MessageBox.Show("From Strong Typed Command"));
                return _showMessage;
            }
            set
            {
                if (_showMessage == value) return;
                _showMessage = value;
                OnPropertyChanged("ShowMessage");
            }
        }
    }
}