class IndexToIsAlternateRowConverter
  def convert(value, target_type, parameter, culture)
    value % 2 == 1
  end

  def convert_back(value, target_type, parameter, culture)
    raise NotImplementedError, "We don't convert back to an index"
  end
end