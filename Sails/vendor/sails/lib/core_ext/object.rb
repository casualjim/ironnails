class Object
  def using(o)
    begin
      yield if block_given?
    ensure
      # TODO: When IronRuby is fixed so that it can call the public overload
      # of the parent class again remove the bool, some classes don't follow that convention.
      o.dispose true if o
    end
  end
  

end

