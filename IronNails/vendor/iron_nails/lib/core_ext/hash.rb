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

  def to_s
    res = self.collect do |k, v|
      val = case
        when v.is_a?(String)
          "\"#{v}\""
        when v.is_a?(Symbol)
          ":#{v}"
        else
          "#{v}"
      end
      "#{k.is_a?(Symbol) ? ":#{k}" : "#{k}" } => #{val}"
    end
    "{ #{res.join(', ')} }"
  end

  alias_method :to_str, :to_s
  alias_method :inspect, :to_s
end