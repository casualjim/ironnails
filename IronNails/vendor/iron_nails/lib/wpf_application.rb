class WpfApplication < System::Windows::Application
  
  def initialize(&b)
    controller = instance_eval &b
    run controller.show_view(false)
  end
    
  def set_skin(name)
    self.resources.merged_dictionaries.add load_skin(name)
  end 
  
  def load_skin(name)
    XamlReader.load_from_path "#{IRONNAILS_ROOT}/skins/#{name}.xaml"
  end 
end