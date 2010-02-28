class Fixnum

  def to_timespan(as=:seconds)
    case as
      when :hours || :hour
        TimeSpan.new(self, 0, 0)
      when :minutes || :minute
        TimeSpan.new(0, self, 0)
      else
        TimeSpan.new(0, 0, self)
    end
  end

  def minutes
    self * 60
  end

  def seconds
    self
  end

end