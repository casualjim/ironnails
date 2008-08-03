class Fixnum
  def to_timespan
    TimeSpan.new(0, self, 0)
  end
end