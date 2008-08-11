namespace IronNails.Models
{
    public class DirectMessage : TweetBase
    {
        #region Fields

        private string _id;
        private User _recipient;
        private string _recipientId;
        private string _recipientScreenName;
        private User _sender;
        private string _senderId;
        private string _senderScreenName;
        private string _text;

        #endregion

        #region Properties

        public string Id
        {
            get { return _id; }
            set
            {
                if (value == _id) return;
                _id = value;
                OnPropertyChanged("MessageId");
            }
        }

        public string Text
        {
            get { return _text; }
            set
            {
                if (value == _text) return;
                _text = value;
                OnPropertyChanged("Text");
            }
        }

        public string SenderId
        {
            get { return _senderId; }
            set
            {
                if (value == _senderId) return;
                _senderId = value;
                OnPropertyChanged("SenderId");
            }
        }

        public string RecipientId
        {
            get { return _recipientId; }
            set
            {
                if (value == _recipientId) return;
                _recipientId = value;
                OnPropertyChanged("RecipientId");
            }
        }

        public string SenderScreenName
        {
            get { return _senderScreenName; }
            set
            {
                if (value == _senderScreenName) return;
                _senderScreenName = value;
                OnPropertyChanged("SenderScreenName");
            }
        }

        public string RecipientScreenName
        {
            get { return _recipientScreenName; }
            set
            {
                if (value == _recipientScreenName) return;
                _recipientScreenName = value;
                OnPropertyChanged("RecipientScreenName");
            }
        }

        public User Sender
        {
            get { return _sender; }
            set
            {
                if (value == _sender) return;
                _sender = value;
                OnPropertyChanged("Sender");
            }
        }

        public User Recipient
        {
            get { return _recipient; }
            set
            {
                if (value == _recipient) return;
                _recipient = value;
                OnPropertyChanged("Recipient");
            }
        }

        #endregion
    }
}