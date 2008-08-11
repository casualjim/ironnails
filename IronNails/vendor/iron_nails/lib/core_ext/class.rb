require File.dirname(__FILE__) + '/class/attribute_accessors' 

class Class

  def demodulize
    self.to_s.gsub(/^.*::/, '')
  end
end