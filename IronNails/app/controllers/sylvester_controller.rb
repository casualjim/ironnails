class SylvesterController < IronNails::Controller::Base

  view_object :status_bar_message
  view_object :tweets, []  
  view_object :username
  view_object :password, :element => :password, :property => :password, :view => :login  
  
  view_action :authenticate #, :mode => :asynchronous, :callback => :logged_in
  view_action :refresh_feeds 
  #view_action :refresh_feeds_timer,
  view_action :toggle_update
  
  
  attr_accessor :current_user, :credentials
  
  def init_controller
    @expanded = false
  end
  
  def default_action
    @status_bar_message = "Please login"
    child_view :login, :in => :content
    on_view(:login) { loaded { username.focus } }
  end 
  
  def refresh_feeds
    @tweets.merge! Status.timeline_with_friends(credentials)
  end
  
  def logged_in
    unless @current_user.nil?
      @tweets = Status.timeline_with_friends credentials    
      @status_bar_message = "Received tweets"
      on_view(:login) do    
        self.visibility= :hidden
        self.password.password = ""
      end
      @username = ""
    end
  end
  
  def view_name
    "main_window"
  end
  
  def toggle_update
    if @expanded
      play_storyboard "CollapseUpdate"
    else
      play_storyboard "ExpandUpdate" 
      on_view do
        self.tweet_text_box.focus
      end
    end
    @expanded = !@expanded
  end 
  
  def authenticate
    @status_bar_message = "Logging in"
    @credentials = Credentials.new @username, @password.to_s.to_secure_string
    @current_user = User.login(credentials)
    logged_in #unless current_user.nil?
  end
  
  def logged_in?
    !credentials.nil?
  end
    

end