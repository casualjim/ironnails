# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ironnails}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ivan Porto Carrero"]
  s.date = %q{2010-03-04}
  s.default_executable = %q{ironnails}
  s.description = %q{IronNails is a framework inspired by the Rails and rucola frameworks. It offers a rails-like way of developing
applications with IronRuby and Windows Presentation Foundation (WPF).}
  s.email = %q{ivan@flanders.co.nz}
  s.executables = ["ironnails"]
  s.files = [
    "Gemfile",
     "Rakefile",
     "VERSION",
     "bin/ironnails",
     "bin/ironnails.bat",
     "generators/base_app/Gemfile",
     "generators/base_app/Rakefile.tt",
     "generators/base_app/app/controllers/application_controller.rb.tt",
     "generators/base_app/app/controllers/default_controller.rb.tt",
     "generators/base_app/app/converters/default_converter.rb.tt",
     "generators/base_app/app/models/model_base.rb.tt",
     "generators/base_app/app/views/main_window.xaml.tt",
     "generators/base_app/assets/skins/default.xaml.tt",
     "generators/base_app/blend_solution.sln.tt",
     "generators/base_app/config/boot.rb.tt",
     "generators/base_app/config/environment.rb.tt",
     "generators/base_app/lib/main.rb.tt",
     "generators/base_app/spec/spec_helper.rb.tt",
     "generators/base_app/src/Properties/AssemblyInfo.cs.tt",
     "generators/base_app/src/Properties/Resources.Designer.cs.tt",
     "generators/base_app/src/Properties/Resources.resx",
     "generators/base_app/src/Properties/Settings.Designer.cs.tt",
     "generators/base_app/src/Properties/Settings.settings",
     "generators/base_app/src/ironnails_controls.csproj.tt",
     "generators/components/component_actions.rb",
     "generators/components/tests/bacon_test_gen.rb",
     "generators/components/tests/rspec_test_gen.rb",
     "generators/generator_actions.rb",
     "generators/skeleton_generator.rb",
     "init.rb",
     "ironnails.gemspec",
     "lib/iron_nails.rb",
     "lib/ironnails.rb",
     "lib/ironnails/bin/IronNails.Library.dll",
     "lib/ironnails/bin/IronNails.Library.pdb",
     "lib/ironnails/bin/IronRuby.Libraries.Yaml.dll",
     "lib/ironnails/bin/IronRuby.Libraries.dll",
     "lib/ironnails/bin/IronRuby.dll",
     "lib/ironnails/bin/Microsoft.Dynamic.dll",
     "lib/ironnails/bin/Microsoft.Scripting.Core.dll",
     "lib/ironnails/bin/Microsoft.Scripting.ExtensionAttribute.dll",
     "lib/ironnails/bin/Microsoft.Scripting.dll",
     "lib/ironnails/config/configuration.rb",
     "lib/ironnails/config/initializer.rb",
     "lib/ironnails/controller.rb",
     "lib/ironnails/controller/base.rb",
     "lib/ironnails/controller/view_operations.rb",
     "lib/ironnails/core_ext.rb",
     "lib/ironnails/core_ext/array.rb",
     "lib/ironnails/core_ext/class.rb",
     "lib/ironnails/core_ext/class/attribute_accessors.rb",
     "lib/ironnails/core_ext/fixnum.rb",
     "lib/ironnails/core_ext/hash.rb",
     "lib/ironnails/core_ext/kernel.rb",
     "lib/ironnails/core_ext/string.rb",
     "lib/ironnails/core_ext/symbol.rb",
     "lib/ironnails/core_ext/system/net/web_request.rb",
     "lib/ironnails/core_ext/system/security/secure_string.rb",
     "lib/ironnails/core_ext/system/windows/markup/xaml_reader.rb",
     "lib/ironnails/core_ext/system/windows/ui_element.rb",
     "lib/ironnails/core_ext/time.rb",
     "lib/ironnails/errors.rb",
     "lib/ironnails/iron_xml.rb",
     "lib/ironnails/logger.rb",
     "lib/ironnails/logging/buffered_logger.rb",
     "lib/ironnails/logging/class_logger.rb",
     "lib/ironnails/models.rb",
     "lib/ironnails/models/base.rb",
     "lib/ironnails/models/bindable_collection.rb",
     "lib/ironnails/models/model_mixin.rb",
     "lib/ironnails/nails_engine.rb",
     "lib/ironnails/observable.rb",
     "lib/ironnails/security/secure_string.rb",
     "lib/ironnails/version.rb",
     "lib/ironnails/view.rb",
     "lib/ironnails/view/collections.rb",
     "lib/ironnails/view/commands.rb",
     "lib/ironnails/view/commands/add_sub_view_command.rb",
     "lib/ironnails/view/commands/behavior_command.rb",
     "lib/ironnails/view/commands/command.rb",
     "lib/ironnails/view/commands/event_command.rb",
     "lib/ironnails/view/commands/timed_command.rb",
     "lib/ironnails/view/view.rb",
     "lib/ironnails/view/view_model.rb",
     "lib/ironnails/view/xaml_proxy.rb",
     "lib/ironnails/wpf.rb",
     "lib/ironnails/wpf_application.rb"
  ]
  s.homepage = %q{http://github.com/casualjim/ironnails}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{IronNails brings rails like development to IronRuby and WPF}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["= 0.11.8"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_runtime_dependency(%q<bundler>, ["= 0.9.2"])
      s.add_runtime_dependency(%q<uuidtools>, [">= 2.1.1"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<thor>, ["= 0.11.8"])
      s.add_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_dependency(%q<bundler>, ["= 0.9.2"])
      s.add_dependency(%q<uuidtools>, [">= 2.1.1"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<thor>, ["= 0.11.8"])
    s.add_dependency(%q<activesupport>, [">= 2.3.5"])
    s.add_dependency(%q<bundler>, ["= 0.9.2"])
    s.add_dependency(%q<uuidtools>, [">= 2.1.1"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end

