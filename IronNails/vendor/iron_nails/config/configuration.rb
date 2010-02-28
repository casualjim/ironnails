# A wrapper module that will contain all the relevant objects for our twitter application
module IronNails

  # This structure has been heavily inspired by the rails framework.
  # The Configuration class holds all the parameters for the Initializer
  # Usually, you'll create a Configuration file implicitly through the block
  # running on the Initializer, but it's also possible to create 
  # the Configuration instance in advance and pass it in
  # like this:
  #
  #   config = IronNails::Configuration.new
  #   IronNails::Initializer.run(config)
  class Configuration

    # the root path for our application
    attr_reader :root_path

    # the search paths for ruby source files
    attr_reader :application_paths

    # the search paths for .NET binaries
    attr_reader :assembly_paths

    # the namespaces that need to be included by default
    attr_reader :namespaces

    # the files that won't be initialized through this procedure
    attr_reader :excluded_files

    # The log level to use for the default Rails logger. In production mode,
    # this defaults to <tt>:info</tt>. In development mode, it defaults to
    # <tt>:debug</tt>.
    attr_accessor :log_level

    # The path to the log file to use. Defaults to log/#{environment}.log
    # (e.g. log/development.log or log/production.log).
    attr_accessor :log_path

    # The specific logger to use. By default, a logger will be created and
    # initialized using #log_path and #log_level, but a programmer may
    # specifically set the logger to use via this accessor and it will be
    # used directly.
    attr_accessor :logger

    def initialize(rpath = (File.dirname(__FILE__) + '/../../..'))
      @root_path = rpath
      initialize_with_defaults
    end

    def environment
      ::IRONNAILS_ENV
    end

    # The paths that contain sources for our application.
    # We will require these at a later stage
    def default_application_paths
      paths = []

      # Followed by the standard includes.
      paths.concat %w(
          config
          lib
          lib/core_ext
          app
          app/models
          app/controllers
          app/converters
          app/helpers
      ).map { |dir| "#{root_path}/#{dir}" }.select { |dir| File.directory?(dir) }
    end

    #files to exclude from requiring in our app
    def default_excluded_files
      ['config/environment.rb', 'lib/main.rb', 'config/boot.rb', 'bin/IronNails.Library.dll' ].collect{ |dir| "#{root_path}/#{dir}" }
    end

    def default_log_level
      (IRONNAILS_ENV == 'development' || IRONNAILS_ENV.nil?) ? :debug : :info
    end

    def default_log_path
      File.join(root_path, 'log', "#{environment}.log")
    end

    # returns wheter or not the specified path is an excluded file
    def excluded_file?(file_path)
      excluded_files.include? file_path
    end

    # The paths that contain .NET binaries
    def default_assembly_paths
      paths = []
      paths.concat %w( bin ).map{ |dir| "#{root_path}/#{dir}"}.select{ |dir| File.directory?(dir) }
    end

    def default_namespaces
      %w(
        System
        System::Net
        System::Xml
        System::IO
        System::Web
        System::Text
        System::Threading
        System::Windows
        System::Collections::ObjectModel
        IronNails::Controller
        IronNails::View
      )
    end

    def initialize_with_defaults
      set_root_path!
      @application_paths, @assembly_paths, @namespaces, @excluded_files = default_application_paths, default_assembly_paths, default_namespaces, default_excluded_files
      @log_level, @log_path = default_log_level, default_log_path
    end

    # Set the root_path to IRONNAILS_ROOT and canonicalize it.
    def set_root_path!
      raise 'IRONNAILS_ROOT is not set' unless defined?(::IRONNAILS_ROOT)
      raise 'IRONNAILS_ROOT is not a directory' unless File.directory?(::IRONNAILS_ROOT)

      @root_path =
              # Pathname is incompatible with Windows, but Windows doesn't have
              # real symlinks so File.expand_path is safe.
              if ENV['OS'] == 'Windows_NT'.freeze
                File.expand_path(::IRONNAILS_ROOT)

                # Otherwise use Pathname#realpath which respects symlinks.
              else
                Pathname.new(::IRONNAILS_ROOT).realpath.to_s
              end

      Object.const_set(:RELATIVE_SAILS_ROOT, ::IRONNAILS_ROOT.dup) unless defined?(::RELATIVE_SYLVESTER_ROOT)

      ::IRONNAILS_ROOT.replace @root_path
    end

  end

end