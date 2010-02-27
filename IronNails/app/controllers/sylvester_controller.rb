class SylvesterController < IronNails::Controller::Base

  # TODO: introduce show_view also in the default action and make the controller responsible for showing that view
  # TODO: introduce a way to start and stop timers
  # TODO: Fix asynchronous execution.
  #       make a command responsible for deciding on an asynchronous operation. Every command should be bound to a view
  #       because multithreading seems to only work correctly from the xaml_proxy. 

  view_object :status_bar_message
  view_object :tweets, []
  view_object :username
  view_object :password, :element => :password, :property => :password, :view => :login
  view_object :update_text

  view_action :authenticate #, :mode => :asynchronous, :callback => :logged_in
  view_action :refresh_tweets
  view_action :refresh_tweets_timer, :action  => :refresh_tweets, :type => :timed, :interval => 2.minutes
  view_action :toggle_update
  view_action :update_status


  attr_accessor :current_user, :credentials

  def init_controller
    @expanded = false
  end

  def update_status
    tweet = Status.update_status @update_text.to_s.with_shortened_urls, credentials
    @status_bar_message = "Tweet sent"
    play_storyboard 'CollapseUpdate'
    @expanded = false
    @update_text = ''
    @tweets.insert 0, tweet if tweet
  end

  def default_action
    @status_bar_message = "Please login"
    child_view :login, :in => :content
    on_view(:login) { |proxy| proxy.loaded { proxy.username.focus } }
  end

  def refresh_tweets
    @tweets.merge! Status.timeline_with_friends(credentials)
    @status_bar_message = "Refreshed tweets"
  end

  def logged_in
    unless @current_user.nil?
      @tweets = Status.timeline_with_friends credentials
      @status_bar_message = "Received tweets"
      on_view(:login) do |proxy|
        proxy.visibility= :hidden
        proxy.password.password = ""
      end
      @username = ""

    end
  end

  def view_name
    "main_window"
  end

  def toggle_update
    if logged_in?
      if @expanded
        play_storyboard "CollapseUpdate"
      else
        play_storyboard "ExpandUpdate"
        on_view do |proxy|
          proxy.tweet_text_box.focus
        end
      end
      @expanded = !@expanded
    end
  end

  def authenticate
    puts "authenticating"
    logger.debug "Setting status message"
    @status_bar_message = "Logging in"
    logger.debug "refreshing view"
    refresh_view
    logger.debug "creating credentials #{@username}, #{@password}"
    @credentials = Credentials.new @username, @password.to_s.to_secure_string
    logger.debug "logging in"
    @current_user = User.login(credentials)
    logger.debug "logged in"
    logged_in #unless current_user.nil?
  end

  def logged_in?
    !credentials.nil?
  end


end