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
  
  def to_clr_value
#    removed because it looks like string is the only special case
#    case self.class
#      when String: self.to_clr_string 
#      else
#       self 
#    end
    self.class == String ? self.to_clr_string : self
  end

end

