#libs_include = "-I 'C:\\tools\\ironruby\\libs;C:\\tools\\ruby\\lib\\ruby\\site_ruby\\1.8;C:\\tools\\ruby\\lib\\ruby\\1.8'"
require 'yaml'
require 'ftools'
libs_include = ""


def exec_sys(cmd)
  puts cmd
  system cmd
end

desc "Run the application"
task :run => [:build] do
  exec_sys "ir #{libs_include} lib/main.rb"
end

namespace :run do
  
  desc "Run the application with debugging enabled"
  task :debug  => [:build] do
    exec_sys "ir #{libs_include} -D lib/main.rb"
  end
  
  desc "Forces this application to run without building first"
  task :force do
    exec_sys "ir #{libs_include} -D lib/main.rb"
  end
  
end

desc "Builds the helpers and the contracts projects"
task :build => ['build:helpers', 'build:contracts', "build:copy_assemblies"]

namespace :build do

  desc "Copies the library assembly to the ironruby directory"
  task :copy_assemblies do    
    ir_path = YAML::load_file('config/build_config.yml')[:ironruby_path.to_s]
    File.copy("../libs/IronNails.Library.dll", "#{ir_path}" )
    File.copy("../libs/J832.Common.dll", "#{ir_path}" )
    File.copy("../libs/J832.Wpf.BagOTricksLib.dll", "#{ir_path}" )
  end

  desc "Build the helpers project" 
  task :helpers do
    system "msbuild /nologo ../IronNails.Library/IronNails.Library.csproj" 
  end
  
  desc "Build the contracts project" 
  task :contracts do
    system "msbuild /nologo ../IronNails.Contracts/IronNails.Contracts.csproj" 
  end

end

desc "Opens a console with the environment of the application initialized (Doesn't work at the moment)"
task :console do
  system "ir #{libs_include} -D -i config/boot.rb"
end

task :default do 
  Rake.application.options.show_tasks = true
  Rake.application.options.show_task_pattern = Regexp.new('.')
  Rake.application.display_tasks_and_comments
end