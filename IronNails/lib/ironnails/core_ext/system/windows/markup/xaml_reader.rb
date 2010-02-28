class System::Windows::Markup::XamlReader

  def self.load_from_path(path)
    self.load XmlReader.create(path)
  end
end