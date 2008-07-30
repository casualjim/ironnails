class TestController < Sails::Controller::Base
  
  def initialize
    load_view    
    super 
    people = []
    people << Person.new(1, "ivan", 30)
    people << Person.new(2, "jeff", 25)
    people << Person.new(3, "mark", 38)
    people << Person.new(4, "vicky", 33)
    
    list.items_source = people
    
  end 
  
  
end