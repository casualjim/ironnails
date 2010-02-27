class Time

  def humanize
    humanized_time = ""
    delta = Time.now - self
    case
      when delta <= 1
        humanized_time = "just now"
      when delta < 60
        humanized_time = "#{delta.floor} seconds ago"
      when delta < 120
        humanized_time = "about a minute ago"
      when delta < (45 * 60)
        humanized_time = "#{(delta / 60).round} minutes ago"
      when delta < (90 * 60)
        humanized_time = "about an hour ago"
      when delta < (86400)
        humanized_time = "about #{(delta /3600 ).round } hours ago"
    when delta < (48 * 3600) 
      humanized_time = "1 day ago"
    else
      humanized_time = "#{(delta / 86400).round} days ago"
    end
    
    humanized_time    
  end 
end
