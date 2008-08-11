using System;

namespace IronNails.Models
{
    public class User : ModelBase
    {
        #region Fields

        private DateTime? _createdAt;
        private string _description;
        private string _favouritesCount;
        private string _followersCount;
        private string _following;
        private string _friendsCount;
        private string _id;
        private string _location;
        private string _name;
        private string _profileImageUrl;
        private string _protected;
        private string _screenName;
        private Status _status;
        private string _statusesCount;
        private string _timeZone;
        private string _url;
        private string _utcOffset;

        #endregion

        #region Properties

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

        public string Name
        {
            get { return _name; }
            set
            {
                if (value == _name) return;
                _name = value;
                OnPropertyChanged("Name");
            }
        }

        public string ScreenName
        {
            get { return _screenName; }
            set
            {
                if (value == _screenName) return;
                _screenName = value;
                OnPropertyChanged("ScreenName");
            }
        }

        public string Location
        {
            get { return _location; }
            set
            {
                if (value == _location) return;
                _location = value;
                OnPropertyChanged("Location");
            }
        }

        public string Description
        {
            get { return _description; }
            set
            {
                if (value == _description) return;
                _description = value;
                OnPropertyChanged("Description");
            }
        }

        public string ProfileImageUrl
        {
            get { return _profileImageUrl; }
            set
            {
                if (value == _profileImageUrl) return;
                _profileImageUrl = value;
                OnPropertyChanged("ProfileImageUrl");
            }
        }

        public string Url
        {
            get { return _url; }
            set
            {
                if (value == _url) return;
                _url = value;
                OnPropertyChanged("Url");
            }
        }

        public string Protected
        {
            get { return _protected; }
            set
            {
                if (value == _protected) return;
                _protected = value;
                OnPropertyChanged("Protected");
            }
        }

        public string FollowersCount
        {
            get { return _followersCount; }
            set
            {
                if (value == _followersCount) return;
                _followersCount = value;
                OnPropertyChanged("FollowersCount");
            }
        }

        public Status Status
        {
            get { return _status; }
            set
            {
                if (value == _status) return;
                _status = value;
                OnPropertyChanged("Status");
            }
        }


        public string FriendsCount
        {
            get { return _friendsCount; }
            set
            {
                if (value == _friendsCount) return;
                _friendsCount = value;
                OnPropertyChanged("FriendsCount");
            }
        }

        public DateTime? CreatedAt
        {
            get { return _createdAt; }
            set
            {
                if (value == _createdAt) return;
                _createdAt = value;
                OnPropertyChanged("CreatedAt");
            }
        }

        public string FavouritesCount
        {
            get { return _favouritesCount; }
            set
            {
                if (value == _favouritesCount) return;
                _favouritesCount = value;
                OnPropertyChanged("FavouritesCount");
            }
        }

        public string UtcOffset
        {
            get { return _utcOffset; }
            set
            {
                if (value == _utcOffset) return;
                _utcOffset = value;
                OnPropertyChanged("UtcOffset");
            }
        }

        public string TimeZone
        {
            get { return _timeZone; }
            set
            {
                if (value == _timeZone) return;
                _timeZone = value;
                OnPropertyChanged("TimeZone");
            }
        }

        public string Following
        {
            get { return _following; }
            set
            {
                if (value == _following) return;
                _following = value;
                OnPropertyChanged("Following");
            }
        }

        public string StatusesCount
        {
            get { return _statusesCount; }
            set
            {
                if (value == _statusesCount) return;
                _statusesCount = value;
                OnPropertyChanged("StatusesCount");
            }
        }

        public string TwitterUrl
        {
            get { return string.Format("http://twitter.com/{0}", _screenName); }
        }

        public string FullName
        {
            get { return string.Format("{0} ({1})", Name, ScreenName); }
        }


        #endregion
    }
}