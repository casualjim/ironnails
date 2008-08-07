class TestController < IronNails::Controller::Base
  
  view_action :show_message, :triggers => [:my_button]
  view_object :people, Person.find_all
    
  def show_message
    MessageBox.show "This is the great message"
  end
  
end