using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;

namespace IronNails.Controls
{
    /// <summary>
    /// Custom TextBlock to allow parsing hyperlinks and @names
    /// </summary>
    public class TweetTextBlock : TextBlock
    {
        #region Dependency properties

        public string TweetText
        {
            get { return (string)GetValue(TweetTextProperty); }
            set { SetValue(TweetTextProperty, value); }
        }

        // Using a DependencyProperty as the backing store for TweetText.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty TweetTextProperty =
            DependencyProperty.Register("TweetText", typeof(string), typeof(TweetTextBlock),
            new FrameworkPropertyMetadata(string.Empty, new PropertyChangedCallback(OnTweetTextChanged)));

        #endregion

        private static void OnTweetTextChanged(DependencyObject obj, DependencyPropertyChangedEventArgs args)
        {
            var text = args.NewValue as string;
            if (text.IsEmpty()) return;

            text = HttpUtility.HtmlDecode(text);

            var textblock = (TweetTextBlock)obj;
            textblock.Inlines.Clear();

            text.Split(' ').ToList().ForEach(word => ProcessWord(textblock, word));
        }

        private static void ProcessWord(TextBlock textblock, string word)
        {
            if (!HasUrls(textblock, word) && !HasAtName(textblock, word))
                textblock.Inlines.Add(word);

            textblock.Inlines.Add(" ");
        }

        private static bool HasAtName(TextBlock textblock, string word)
        {
            if (!word.IsAtName()) return false;

            var foundUsername = Regex.Match(word, @"@(\w+)");
            if (!foundUsername.Success) return false;

            var userName = foundUsername.Groups[1].Captures[0].Value;
            var name = new Hyperlink
            {
                NavigateUri = new Uri("http://twitter.com/" + userName),
                ToolTip = "Show user's profile"
            };

            name.Inlines.Add(userName);
            name.Click += (sender, e) => ((Hyperlink)sender).NavigateUri.TryOpeningUrl();

            textblock.Inlines.Add("@");
            textblock.Inlines.Add(name);

            return true;
        }

        private static bool HasUrls(TextBlock textblock, string text)
        {
            if (!text.IsUrl()) return false;

            try
            {
                var link = new Hyperlink
                {
                    NavigateUri = new Uri(text),
                    ToolTip = "Open link in the default browser"
                };
                link.Inlines.Add(text);
                link.Click += (sender, e) => ((Hyperlink)sender).NavigateUri.TryOpeningUrl();
                textblock.Inlines.Add(link);

                return true;
            }
            catch
            {
                textblock.Inlines.Add(text);
                return false;
            }
        }


        public static readonly RoutedEvent NameClickEvent = EventManager.RegisterRoutedEvent(
            "NameClick", RoutingStrategy.Bubble, typeof(RoutedEventHandler), typeof(TweetTextBlock));

        public event RoutedEventHandler NameClick
        {
            add { AddHandler(NameClickEvent, value); }
            remove { RemoveHandler(NameClickEvent, value); }
        }

    }
}