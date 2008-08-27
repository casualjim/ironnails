class WpfApplication < System::Windows::Application
  
  include IronNails::Logging::ClassLogger
  
  attr_reader :view_manager
  
  def initialize(&b)
    logger.debug "Loading initial window", IRONNAILS_FRAMEWORKNAME
    @view_manager = ViewManager.new
    #@view_manager = TestViewManager.new
    controller = instance_eval &b
    view_manager.register_controller controller
    view_manager.show_initial_window controller do |view_instance|
      @main_window = view_instance
      run view_instance
    end
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