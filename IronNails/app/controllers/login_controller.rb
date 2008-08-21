class LoginController < IronNails::Controller::Base
  
  view_object :username
  view_object :password
  
  view_action :authenticate
  
  def initialize
    
  end 
  
  def authenticate
    MessageBox.show("Authenticating in Login", "Authenticating")
  end
end 