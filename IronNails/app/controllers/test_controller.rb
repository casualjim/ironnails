class TestController < IronNails::Controller::Base
  
  view_action :show_message, :triggers => :my_button do
    MessageBox.show "This is the great message from a block"
  end
  
  view_action :change_color, :triggers => { :element => :my_text_block, :event => :mouse_enter }
  view_action :reset_color, :triggers => { :element => :my_text_block, :event => :mouse_leave } do |view|
    view.my_text_block.foreground = :black.to_brush
  end
  
  view_object :people, Person.find_all
    
  def change_color(view)
    view.my_text_block.foreground = :red.to_brush
  end
  
  
end