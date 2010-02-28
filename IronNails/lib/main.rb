require File.dirname(__FILE__) + "/../config/environment"

WpfApplication.new do

  set_skin :aero
  SylvesterController.new
end