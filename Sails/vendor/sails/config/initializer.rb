module Sails
  
  # This structure has been heavily inspired by the rails framework.
  # The Configuration class holds all the parameters for the Initializer
  # Usually, you'll create a Configuration file implicitly through the block
  # running on the Initializer, but it's also possible to create 
  # the Configuration instance in advance and pass it in
  # like this:
  #
  #   config = Sails::Configuration.new
  #   Sails::Initializer.run(config)
  class Initializer
    
    attr_reader :configuration
    
    def initialize(configuration)
      @configuration = configuration
      
      set_constants
      require_binaries
      include_namespaces
      require_application_files
    end
    
    def self.run(configuration = Configuration.new)
      yield configuration if block_given?
      initializer = new configuration
      initializer
    end
    
    def set_constants
      
    end
    
    def require_binaries
      configuration.assembly_paths.each do |path|
        require_files path, :dll
      end
    end
    
    def include_namespaces
      configuration.namespaces.each { |namespace| Object.include eval(namespace) }
    end 
    
    def require_application_files
      configuration.application_paths.each do |path|
        require_files path, :rb
      end
    end 
    
    def require_files(path, extension)
      Dir.glob("#{File.expand_path(path)}/*.#{extension}").each do |file| 
        #        puts "#{file}"
        require "#{file}" unless configuration.excluded_file? file
      end
    end
    
  end
  
end