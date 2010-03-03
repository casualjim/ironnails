module IronNails
  module ComponentActions
    # Adds all the specified gems into the Gemfile for bundler
    # require_dependencies 'activerecord'
    # require_dependencies 'mocha', 'bacon', :group => :testing
    def require_dependencies(*gem_names)
      options = gem_names.extract_options!
      gem_names.reverse.each { |lib| insert_into_gemfile(lib, options) }
    end

    # Inserts a required gem into the Gemfile to add the bundler dependency
    # insert_into_gemfile(name)
    # insert_into_gemfile(name, :group => :testing)
    def insert_into_gemfile(name, options={})
      after_pattern = "# Component requirements\n"
      after_pattern = "# #{options[:group].to_s.capitalize} requirements\n" if group = options[:group]
      include_text = "gem '#{name}'"
      include_text << ", :require => #{options[:require].inspect}" if options[:require]
      include_text << ", :group => #{group.inspect}" if group
      include_text << "\n"
      options.merge!(:content => include_text, :after => after_pattern)
      inject_into_file('Gemfile', options[:content], :after => options[:after])
    end

    # Injects the test class text into the test_config file for setting up the test gen
    # insert_test_suite_setup('...CLASS_NAME...')
    # => inject_into_file("spec/spec_helper.rb", TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    def insert_test_suite_setup(suite_text, options={})
      options.reverse_merge!(:path => "spec/spec_helper.rb", :after => /Spec configuration\n/)
      inject_into_file(options[:path], suite_text.gsub(/CLASS_NAME/, @class_name), :after => options[:after])
    end

    # Returns space characters of given count
    # indent_spaces(2)
    def indent_spaces(count)
      ' ' * count
    end
  end
end