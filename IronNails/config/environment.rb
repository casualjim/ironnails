require File.dirname(__FILE__) + "/boot"
# IronNails::Logging::FRAMEWORK_LOGGING = false
IronNails::Logging::CONSOLE_LOGGING = true

#require 'twitter'

IronNails::Initializer.run do |config|

  config.namespaces.concat %w(
          IronNails
          IronNails::Core
          IronNails::Models
          System::Diagnostics
          System::Security
          System::Globalization
          System::Windows::Markup
          System::Windows::Controls
          System::Windows::Media
          System::Windows::Media::Animation
          System::Windows::Threading
          System::Windows::Input
  )
end