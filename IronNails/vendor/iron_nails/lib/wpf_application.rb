class WpfApplication < System::Windows::Application
  
  include IronNails::Logging::ClassLogger
  
  def initialize(&b)
    logger.debug "Loading initial window", IRONNAILS_FRAMEWORKNAME
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