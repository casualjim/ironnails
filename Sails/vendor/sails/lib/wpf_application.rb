class WpfApplication < System::Windows::Application
  
  def initialize(&b)
    @@window = instance_eval &b
    run @@window
  end
  
  def self.current_window
    @@window
  end
  
  def set_skin(name)
    self.resources.merged_dictionaries.add load_skin(name)
  end 
  
  def load_skin(name)
    XamlReader.load_from_path "#{SAILS_ROOT}/skins/#{name}.xaml"
  end 
end