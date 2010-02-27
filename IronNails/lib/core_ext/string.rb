class String

  # returns the string with snipr urls where appropriate
  def with_shortened_urls
    split_in_words = self.split(' ').collect do |word|
      word.is_url? ? SniprUrl.new(word).shorten : word
    end
    split_in_words.join(' ')
  end

  def is_direct_message?
    !!(/^d\s/i =~ self)
  end

  def to_clr_char
    self.to_clr_string.to_char_array[0]
  end

  def to_created_time
    Time.parse self
  end

  def truncate_tweet
    if self.size > 140
      s = self[0...135]
      return s.split(' ')[0...s.split(' ').size - 1].join(' ')
    end
    self
  end

end