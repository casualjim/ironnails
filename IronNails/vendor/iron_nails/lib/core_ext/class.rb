class Class

  def demodulize
    self.to_s.gsub(/^.*::/, '')
  end
end