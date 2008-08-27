class MainWindowController < IronNails::Controller::Base

  view_object :status_bar_message, "The message"
  
  view_object :username, "Hello"
  view_object :password #, :type => :password
  
  view_action :authenticate
  view_action :refresh_feeds  
  
  def refresh_feeds
    logger.debug "refreshing feeds"
    child_view :login, :in => :content
    on_view(:login) { loaded { username.focus } }
  end
  
  def logged_in
    puts "logged in"
    on_view(:login) do
      self.visibility= :hidden
    end
  end
  
  def view_name
    "main_window"
  end
  
  def authenticate
    logged_in
  end
    

end