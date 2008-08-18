class String
  
  # ensures that our url starts with at least http
  def ensure_http
    return "http://#{self}" unless /^(ht|f)tp:\/\/.*/i.match(self)
    self
  end 
  
  # returns whether this string is a well formed url
  def is_url?
    !!(Uri.is_well_formed_uri_string(self.to_clr_string, UriKind.Absolute) && /^(ht|f)tp/i.match(Uri.new(self).scheme))
  end
  
  def strip_html
    self.gsub(/<(.|\n)*?>/, '')
  end
  
  def camelize(first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      self.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    else
      self[0...1].downcase + camelize(self)[1..-1]
    end
  end
  
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  
  def to_clr_char
    self.to_clr_string.to_char_array[0]
  end
  
  def to_secure_string
    Twitter::Security::SecureString.to_secure_string self
  end 
  
  def decrypt
    Twitter::Security::SecureString.decrypt_string self
  end 
  
  def classify
    Kernel.const_get(self.camelize)
  end
    
  def truncate(max=140)
    if self.size > max
      s = self[0...max-5]
      return s.split(' ')[0...s.split(' ').size - 1].join(' ')
    end
    self
  end
  
end