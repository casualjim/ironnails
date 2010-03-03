require 'thor/group'
require 'uuidtools'
require File.dirname(__FILE__) + '/generator_actions'
require File.dirname(__FILE__) + '/components/component_actions'
Dir[File.dirname(__FILE__) + "/{base_app,components}/**/*.rb"].each { |lib| require lib }

module IronNails
  class SkeletonGenerator < Thor::Group
    # Define the source template root
    def self.source_root; File.dirname(__FILE__); end
    def self.banner; "ironnails_gen [app_name] [path] [options]"; end

    # Include related modules
    include Thor::Actions
    include IronNails::GeneratorActions
    include IronNails::ComponentActions

    desc "Description:\n\n\tironnails_gen is the ironnails generator which generates an application skeleton and later on components"

    argument :name, :desc => "The name of your ironnails app"
    argument :path, :desc => "The path to create your app"
    class_option :run_bundler, :aliases => '-b', :default => false, :type => :boolean

    # Definitions for the available customizable components
#    component_option :orm,      "database engine",    :aliases => '-d', :choices => [:datamapper, :mongomapper, :activerecord, :sequel, :couchrest]
    component_option :test,     "testing framework",  :aliases => '-t', :choices => [:rspec, :bacon]
#    component_option :mock,     "mocking library",    :aliases => '-m', :choices => [:caricature, :mocha, :rr]

    # Copies over the base ironnails starting application
    def setup_skeleton
      self.destination_root = File.join(path, name)
      @class_name = name.classify
      @guid = UUIDTools::UUID.timestamp_create.to_s
      directory("base_app/", self.destination_root)
      store_component_config('.components')
    end

    # For each component, retrieve a valid choice and then execute the associated generator
    def setup_components
      self.class.component_types.each do |comp|
        choice = resolve_valid_choice(comp)
        execute_component_setup(comp, choice)
      end
    end

    # Bundle all required components using bundler and Gemfile
    def bundle_dependencies
      if options[:run_bundle]
        say "Bundling application dependencies using bundler..."
        in_root { run 'bundle install' }
      end
    end
  end
end