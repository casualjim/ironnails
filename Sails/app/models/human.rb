class Human

  attr_accessor :id, :name, :age
  
  def initialize(id, name, age)
    @id, @name, @age = id, name, age
  end

  def name
    yield
    @name
  end
end