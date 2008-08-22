class MainWindowController < IronNails::Controller::Base

  view_object :status_bar_message, "The message"
  
  view_object :username, "Hello"
  view_object :password #, :type => :password
  
  view_action :authenticate
  
  view_action :refresh_feeds  
  
  def refresh_feeds
    puts "refreshing feeds"
    add_child_view :content, :login
  end
  
  def logged_in
    puts "logged in"
  end
  
  def authenticate
    logged_in
  end
    

end