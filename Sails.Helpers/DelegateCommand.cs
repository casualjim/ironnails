#region Usings

using System;
using System.Windows.Input;

#endregion

namespace Sails.Helpers
{
    /// <summary>
    /// A command that will execute a delegate
    /// </summary>
    public class DelegateCommand : ICommand
    {
        #region Delegates

        public delegate void SimpleEventHandler();

        #endregion

        private readonly SimpleEventHandler handler;

        private bool isEnabled = true;


        /// <summary>
        /// Initializes a new instance of the <see cref="DelegateCommand"/> class.
        /// </summary>
        /// <param name="handler">The handler.</param>
        public DelegateCommand(SimpleEventHandler handler)
        {
            this.handler = handler;
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
            return IsEnabled;
        }


        /// <summary>
        /// Executes the specified arg.
        /// </summary>
        /// <param name="arg">The arg.</param>
        void ICommand.Execute(object arg)
        {
            handler();
        }

        #endregion

        private void OnCanExecuteChanged()
        {
            if (CanExecuteChanged != null)
            {
                CanExecuteChanged(this, EventArgs.Empty);
            }
        }
    }
}