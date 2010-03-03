class WpfApplication < System::Windows::Application

  include IronNails::Logging::ClassLogger

  attr_reader :nails_engine

  def initialize(&b)
    logger.debug "Starting application", IRONNAILS_FRAMEWORKNAME
    @nails_engine = NailsEngine.new
    controller = instance_eval &b
    nails_engine.register_controller controller
    nails_engine.show_initial_window controller do |view_instance|
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

  def load_skin(name=:default)
    XamlReader.load_from_path skins_path("#{name}.xaml")
  end
end