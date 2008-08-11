namespace IronNails.Models
{
    public class Status : TweetBase
    {
        #region Fields

        private bool _favorited;
        private string _id;
        private string _inReplyToStatusId;
        private string _inReplyToUserId;
        private string _source;
        private string _sourceUrl;
        private string _text;
        private string _truncated;
        private User _user;

        #endregion

        #region Properties

        public User User
        {
            get { return _user; }
            set
            {
                if (value == _user) return;
                _user = value;
                OnPropertyChanged("User");
            }
        }

        public string Id
        {
            get { return _id; }
            set
            {
                if (value == _id) return;
                _id = value;
                OnPropertyChanged("Id");
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

        public string Source
        {
            get { return _source; }
            set
            {
                if (value == _source) return;
                _source = value;
                OnPropertyChanged("Source");
            }
        }

        public string SourceUrl
        {
            get { return _sourceUrl; }
            set
            {
                if (value == _sourceUrl) return;
                _sourceUrl = value;
                OnPropertyChanged("SourceUrl");
            }
        }

        public string Truncated
        {
            get { return _truncated; }
            set
            {
                if (value == _truncated) return;
                _truncated = value;
                OnPropertyChanged("Truncated");
            }
        }

        public string InReplyToStatusId
        {
            get { return _inReplyToStatusId; }
            set
            {
                if (value == _inReplyToStatusId) return;
                _inReplyToStatusId = value;
                OnPropertyChanged("InReplyToStatusId");
            }
        }

        public string InReplyToUserId
        {
            get { return _inReplyToUserId; }
            set
            {
                if (value == _inReplyToUserId) return;
                _inReplyToUserId = value;
                OnPropertyChanged("InReplyToUserId");
            }
        }

        public bool Favorited
        {
            get { return _favorited; }
            set
            {
                if (value == _favorited) return;
                _favorited = value;
                OnPropertyChanged("Favorited");
            }
        }

        #endregion
    }
}