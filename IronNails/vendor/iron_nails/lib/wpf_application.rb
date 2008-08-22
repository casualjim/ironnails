class WpfApplication < System::Windows::Application
  
  def initialize(&b)
    puts "Loading initial window"
    controller = instance_eval &b
    @main_window = controller.show_view
    run @main_window
  end
  
  def has_main_window?
    @main_window.nil?
  end
    
  def set_skin(name)
    self.resources.merged_dictionaries.add load_skin(name)
  end 
  
  def load_skin(name)
    XamlReader.load_from_path "#{IRONNAILS_ROOT}/skins/#{name}.xaml"
  end 
end