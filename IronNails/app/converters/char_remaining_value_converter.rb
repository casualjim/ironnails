class CharRemainingValueConverter

  def convert(value, target_type, parameter, culture)
    140 - value
  end

  def convert_back(value, target_type, parameter, culture)
    raise NotImplementedError, "We don't convert back from char remaining"
  end

end