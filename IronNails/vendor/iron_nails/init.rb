puts "initializing ruby libraries and gems"
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

puts "setting constants"
IRONNAILS_ROOT = "#{File.dirname(__FILE__)}/../.." unless defined?(IRONNAILS_ROOT)
IRONNAILS_VIEWS_ROOT = "#{IRONNAILS_ROOT}/app/views" unless defined? IRONNAILS_VIEWS_ROOT
IRONNAILS_ENV = (ENV['IRONNAILS_ENV'] || 'development').dup unless defined?(IRONNAILS_ENV)

# load .NET libraries
puts "loading .NET binaries"
require 'mscorlib'
require 'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
require 'WindowsBase, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'PresentationCore, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'PresentationFramework, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'PresentationFramework.Aero, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'System.Net, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
require 'System.ServiceModel.Web, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Windows.Presentation, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'UIAutomationProvider, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
require 'System.Security, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
require "System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
require "System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

# load IronNails static CLR helpers 
puts "Loading IronNails.Library"
require File.dirname(__FILE__) + '/bin/IronNails.Library.dll'
include IronNails::Helpers

# load IronRuby files of the IronNails framework
puts "Loading the IronNails framework"
require File.dirname(__FILE__) + '/lib/version'
require File.dirname(__FILE__) + '/lib/logger'
require File.dirname(__FILE__) + '/config/configuration'
require File.dirname(__FILE__) + '/config/initializer'
require File.dirname(__FILE__) + '/lib/security/secure_string'
require File.dirname(__FILE__) + '/lib/core_ext'
require File.dirname(__FILE__) + '/lib/errors'
require File.dirname(__FILE__) + '/lib/observable'
require File.dirname(__FILE__) + '/lib/wpf_application'
require File.dirname(__FILE__) + '/lib/view'
require File.dirname(__FILE__) + '/lib/models'
require File.dirname(__FILE__) + '/lib/controller'

