class TestController < IronNails::Controller::Base
  
  view_action :show_message, :triggers => :my_button do |view|
    view.my_text_block.foreground = :red.to_brush
    MessageBox.show "This is the message from a block"
  end
  
#  view_action :change_color, :triggers => { :element => :my_text_block, :event => :mouse_enter } do |view|
#    view.my_text_block.foreground = :red
#  end
  
  view_object :people, Person.find_all
    
  def show_message
    MessageBox.show "This is the great message"
  end
  
end