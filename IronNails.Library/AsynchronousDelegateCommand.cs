#region Usings

using System;
using System.Threading;
using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;

#endregion

namespace IronNails.Library
{
    /// <summary>
    /// Executes a delegate asynchronously
    /// </summary>
    public class AsynchronousDelegateCommand : ICommand
    {
        private readonly Action _handler;
        private readonly Action _callback;
        private Func<bool> _canExecute;

        private bool isEnabled = true;


        /// <summary>
        /// Initializes a new instance of the <see cref="AsynchronousDelegateCommand"/> class.
        /// </summary>
        /// <param name="handler">The _handler.</param>
        /// <param name="callback">The callback.</param>
        public AsynchronousDelegateCommand(Action handler, Action callback)
        {
            _handler = handler;
            _callback = callback;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AsynchronousDelegateCommand"/> class.
        /// </summary>
        /// <param name="handler">The _handler.</param>
        /// <param name="callback">The callback.</param>
        /// <param name="condition">The condition.</param>
        public AsynchronousDelegateCommand(Action handler, Action callback, Func<bool> condition) : this(handler, callback)
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
            get { return isEnabled; }

            set
            {
                isEnabled = value;
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
            ThreadPool.QueueUserWorkItem(v =>
                                             {
                                                 try
                                                 {
                                                     _handler();
                                                     ((UIElement)arg).Dispatcher.BeginInvoke(
                                                         DispatcherPriority.Normal, 
                                                         new Action<object>(o => _callback()),
                                                         new Func<object>(() =>
                                                                              {
                                                                                  _handler();
                                                                                  return null;
                                                                              }));
                                                 }
                                                 catch(Exception ex)
                                                 {
                                                     MessageBox.Show("There was a problem.\r\n" + ex.Message);
                                                 }
                                             });
        }

        #endregion

        private void OnCanExecuteChanged()
        {
            if (CanExecuteChanged == null) return;
            CanExecuteChanged(this, EventArgs.Empty);
        }
    }
}