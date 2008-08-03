libs_include = "-I 'C:\\tools\\ruby\\lib\\ruby\\1.8;C:\\tools\\ruby\\lib\\ruby\\site_ruby\\1.8;C:\\tools\\ironruby\\libs'"

desc "Run the application"
task :run => [:build] do
  system "ir #{libs_include} lib/main.rb"
end

namespace :run do
  
  desc "Run the application with debugging enabled"
  task :debug  => [:build] do
    system "ir #{libs_include} -D lib/main.rb"
  end
  
end

desc "Builds the helpers and the contracts projects"
task :build => ['build:helpers', 'build:contracts']

namespace :build do

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