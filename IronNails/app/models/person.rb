module IronNails::Models
  class Person
  
    
    def self.find_all
      people = System::Collections::Generic::List.of(Person).new
      people.add Person.new(1, "ivan", 30)
      people.add Person.new(2, "jeff", 25)
      people.add Person.new(3, "mark", 38)
      people.add Person.new(4, "vicky", 33)
      people
    end
  end
end