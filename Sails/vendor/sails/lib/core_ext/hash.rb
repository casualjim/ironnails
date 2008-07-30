class Hash
  
  #returns a string of post parameters for http posts, url-encoded
  def to_post_parameters
    params = ""
    
    self.each do |k, v|
      params += "&" unless params.empty?
      params += "#{k}=#{HttpUtility.url_encode(v)}"
    end
    
    params
  end 
end