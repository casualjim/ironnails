require File.dirname(__FILE__) + "/../config/boot"
WpfApplication.new do
  
  #obj = MainWindowController.new
  obj = TestController.new
  obj.view  
end