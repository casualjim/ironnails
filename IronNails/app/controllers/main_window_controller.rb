class MainWindowController < IronNails::Controller::Base

  view_object :status_bar_message, "The message"
  
  view_action :refresh_feeds  
  
  def refresh_feeds
    @login_controller = add_child_view(:content, :login)
    @login_controller.add_observer :logged_in do 
      logged_in 
    end
  end
  
  def logged_in
    puts "logged in"
  end

end