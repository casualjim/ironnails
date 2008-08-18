#region Usings

using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;

#endregion

namespace IronNails.Library
{
    /// <summary>
    /// A command that will execute a delegate
    /// </summary>
    public class DelegateCommand : ICommand
    {
        private readonly Action _handler;
        private readonly Func<bool> _canExecute;

        private bool _isEnabled = true;


        /// <summary>
        /// Initializes a new instance of the <see cref="DelegateCommand"/> class.
        /// </summary>
        /// <param name="handler">The handler.</param>
        public DelegateCommand(Action handler)
        {
            _handler = handler;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DelegateCommand"/> class.
        /// </summary>
        /// <param name="handler">The handler.</param>
        /// <param name="condition">The condition.</param>
        public DelegateCommand(Action handler, Func<bool> condition) : this(handler)
        {
            _canExecute = condition;
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is enabled.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is enabled; otherwise, <c>false</c>.
        /// </value>
        public bool IsEnabled
        {
            get { return _isEnabled; }

            set
            {
                _isEnabled = value;
                OnCanExecuteChanged();
            }
        }

        #region ICommand Members

        public event EventHandler CanExecuteChanged;


        /// <summary>
        /// Determines whether this instance can execute the specified arg.
        /// </summary>
        /// <param name="arg">The arg.</param>
        /// <returns>
        /// 	<c>true</c> if this instance can execute the specified arg; otherwise, <c>false</c>.
        /// </returns>
        bool ICommand.CanExecute(object arg)
        {
            return IsEnabled && (_canExecute == null || _canExecute());
        }


        /// <summary>
        /// Executes the specified arg.
        /// </summary>
        /// <param name="arg">The arg.</param>
        void ICommand.Execute(object arg)
        {
            ((UIElement) arg).Dispatcher.Invoke(DispatcherPriority.Normal, _handler);
        }

        #endregion

        private void OnCanExecuteChanged()
        {
            if (CanExecuteChanged == null) return;
            CanExecuteChanged(this, EventArgs.Empty);
        }
    }
}