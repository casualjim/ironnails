module IronNails

  class << self
    # The Configuration instance used to configure the Rails environment
    def configuration
      @@configuration
    end
    
    def configuration=(configuration)
      @@configuration = configuration
    end
    
    def logger
      IRONNAILS_DEFAULT_LOGGER
    end
    
    def root
      if defined?(IRONNAILS_ROOT)
        IRONNAILS_ROOT
      else
        nil
      end
    end
    
    def env
      IRONNAILS_ENV
    end
    
    def version
      IronNails::VERSION::STRING
    end
    
  end
  
  # This structure has been heavily inspired by the rails framework.
  # The Configuration class holds all the parameters for the Initializer
  # Usually, you'll create a Configuration file implicitly through the block
  # running on the Initializer, but it's also possible to create 
  # the Configuration instance in advance and pass it in
  # like this:
  #
  #   config = IronNails::Configuration.new
  #   IronNails::Initializer.run(config)
  class Initializer
        
    def initialize(configuration)
      IronNails.configuration = configuration
      
      initialize_logger
      
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
    
    def configuration
      IronNails.configuration
    end 
    
    def set_constants
      
    end
    
    # If the IRONNAILS_DEFAULT_LOGGER constant is already set, this initialization
    # routine does nothing. If the constant is not set, and Configuration#logger
    # is not +nil+, this also does nothing. Otherwise, a new logger instance
    # is created at Configuration#log_path, with a default log level of
    # Configuration#log_level.
    #
    # If the log could not be created, the log will be set to output to
    # +STDERR+, with a log level of +WARN+.
    def initialize_logger
      # if the environment has explicitly defined a logger, use it
      return if defined?(IRONNAILS_DEFAULT_LOGGER)
      
      unless logger = configuration.logger
        begin
          logger = IronNails::Logging::BufferedLogger.new(configuration.log_path)
          logger.level = IronNails::Logging::BufferedLogger.const_get(configuration.log_level.to_s.upcase)
          if configuration.environment == "production"
            logger.auto_flushing = false
            logger.set_non_blocking_io
          end
        rescue StandardError => e
          logger = IronNails::Logging::BufferedLogger.new(STDERR)
          logger.level = IronNails::Logging::BufferedLogger::WARN
          logger.warn(
            "IronNails Error: Unable to access log file. Please ensure that #{configuration.log_path} exists and is chmod 0666. " +
            "The log level has been raised to WARN and the output directed to STDERR until the problem is fixed. #{e}" 
          )
        end
      end
      
      silence_warnings { Object.const_set "IRONNAILS_DEFAULT_LOGGER", logger }
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
        puts "#{file}"
        require "#{file}" unless configuration.excluded_file? file
      end
    end
    
  end
  
end