class LoginController < IronNails::Controller::Base
  
  view_object :username, "Hello"
  view_object :password
  
  view_action :authenticate
  
  def initialize
    
  end 
  
  def authenticate
    notify_observers(:logged_in, self)
  end
end 