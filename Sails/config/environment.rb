
Sails::Initializer.run do |config|
  
  config.namespaces.concat %w(
          Sails
          Sails::Contracts
          Sails::Contracts::Models
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