class TestController < Sails::Controller::Base
  
  def initialize
    puts "in test controller initialize"
    #load_view    
    super 
    puts "base should be called right before this"
    people = []
    people << Person.new(1, "ivan", 30)
    people << Person.new(2, "jeff", 25)
    people << Person.new(3, "mark", 38)
    people << Person.new(4, "vicky", 33)
    
    #list.items_source = people
    
  end 
  
  
end