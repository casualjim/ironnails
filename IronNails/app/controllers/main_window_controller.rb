class MainWindowController < IronNails::Controller::Base

  view_object :status_bar_message, "The message"
  view_object :tweets, []
  
  view_object :username
  view_object :password #, :type => :password
  
  view_action :authenticate
  view_action :refresh_feeds 
  
  def default_action
    child_view :login, :in => :content
    on_view(:login) { loaded { username.focus } }
  end 
  
  def refresh_feeds
    logger.debug "refreshing feeds"
    #child_view :login, :in => :content
    #on_view(:login) { loaded { username.focus } }
  end
  
  def logged_in
    password = from_view :login , :get => :password,  :from => :password
    @tweets = Status.timeline_with_friends Credentials.new(@username, password.to_s.to_secure_string)
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