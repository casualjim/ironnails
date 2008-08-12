class MainWindowController < IronNails::Controller::Base

  view_object :status_bar_message, "The message"
  
  view_action :refresh_feeds, :triggers => :refresh_button
  
  def refresh_feeds
    @status_bar_message = "The new message"
    refresh_view
  end

end