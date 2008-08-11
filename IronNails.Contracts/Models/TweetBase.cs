using System;

namespace IronNails.Models
{
    public class TweetBase : ModelBase
    {
        private DateTime? _createdAt;
        private string _humanizedTime;

        public string HumanizedTime
        {
            get { return _humanizedTime; }
            set
            {
                if (value == _humanizedTime) return;
                _humanizedTime = value;
                OnPropertyChanged("HumanizedTime");
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
    }
}