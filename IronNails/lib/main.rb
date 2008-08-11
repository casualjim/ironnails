require File.dirname(__FILE__) + "/../config/boot"

WpfApplication.new do
  
  set_skin :aero
  MainWindowController.new
  #TestController.new
end