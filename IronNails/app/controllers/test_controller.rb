class TestController < IronNails::Controller::Base
  
  view_action :show_message, :triggers => [:my_button, { :element => :my_button2, :event => :left_mouse_button_up }]
  view_object :people, Person.find_all
  
  def initialize
    puts "in test controller initialize"
    #load_view    
    super 
    puts "base should be called right before this"
    
    
    #list.items_source = people
    
  end 
  
  def show_message
    MessageBox.show "This is the great message"
  end
  
end