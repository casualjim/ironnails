class MainWindowController < IronNails::Controller::Base

  view_object :status_bar_message, "The message"
  
  view_action :refresh_feeds
  
  def refresh_feeds
    MessageBox.show "refreshing feeds"
    @status_bar_message = "#@status_bar_message 1"
  end

end