class RoundConverter
  def convert(value, target_type, parameter, culture)
    value.round
  end

  def convert_back(value, target_type, parameter, culture)
    begin
      value.round
    rescue
      0
    end
  end
end