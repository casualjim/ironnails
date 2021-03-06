begin
  require 'logger'
  require 'fileutils'
  require 'forwardable'
rescue LoadError => e
  msg = "It looks like you tried to load the application without passing the"
  msg << " library paths to IronRuby.\n"
  msg << "You can fix that by passing the following switch to ir\n(replace C:\\tools\\ruby and c:\\tools\\ironruby with the paths for your configuration):\n"
  msg << "ir -I 'C:\\tools\\ironruby\\libs;C:\\tools\\ruby\\lib\\ruby\\site_ruby\\1.8;C:\\tools\\ruby\\lib\\ruby\\1.8'\n"
  msg << "or you could change the first line of the rake file (Rakefile.rb) to reflect your configuration\n"
  raise LoadError.new(msg)
end

IRONNAILS_ROOT = "#{File.dirname(__FILE__)}/../.." unless defined?(IRONNAILS_ROOT)
IRONNAILS_VIEWS_ROOT = "#{IRONNAILS_ROOT}/app/views" unless defined? IRONNAILS_VIEWS_ROOT
IRONNAILS_ENV = (ENV['IRONNAILS_ENV'] || 'development').dup unless defined?(IRONNAILS_ENV)
IRONNAILS_FRAMEWORKNAME = "IronNails Framework" unless defined?(IRONNAILS_FRAMEWORKNAME)

nails_vendor_lib = File.join(IRONNAILS_ROOT, "vendor/ironnails")
$:.unshift nails_vendor_lib if File.exist? nails_vendor_lib
$:.unshift File.expand_path(File.dirname(__FILE__))
$:.unshift File.expand_path(File.dirname(__FILE__) + "ironnails/bin")

%w(app/views app/helpers app/converters app/controllers app/models lib bin).each do |pth|
  $:.unshift File.join(IRONNAILS_ROOT, pth)
end

# load .NET libraries
require 'System'
require 'WindowsBase'
require 'PresentationCore'
require 'PresentationFramework'
require 'System.Windows.Forms'
require 'System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
require 'WindowsBase, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'PresentationFramework.Aero, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'System.Net, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
require 'System.ServiceModel.Web, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Windows.Presentation, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'UIAutomationProvider, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Security, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
require "System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

# load IronNails static CLR helpers
require 'ironnails/bin/IronNails.Library.dll'
lst = System::Collections::Generic::List.of(System::String).new
$:.each {|pth| lst.add pth.to_clr_string }
IronNails::Library::DlrHelper.load_paths = lst
IronNails::Library::DlrHelper.app_root = IRONNAILS_ROOT

# load IronRuby files of the IronNails framework
require 'ironnails/version'
require 'ironnails/logger'
require 'ironnails/config/configuration'
require 'ironnails/config/initializer'
require 'ironnails/security/secure_string'
require 'ironnails/core_ext'
require 'ironnails/errors'
require 'ironnails/observable'
require 'ironnails/iron_xml'
require 'ironnails/view'
require 'ironnails/models'
require 'ironnails/controller'
require 'ironnails/nails_engine'
require 'ironnails/wpf_application'

