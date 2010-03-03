module IronNails
  module RspecTestGen
    RSPEC_SETUP = <<-TEST
\nSpec::Runner.configure do |config|
  config.mock_with Caricature::RSpecAdapter
  config.include Caricature::RSpecMatchers
end


TEST

    def setup_test
      insert_into_gemfile 'caricature', :require => 'caricature', :group => :testing
      insert_into_gemfile 'rspec', :require => 'spec', :group => :testing
      insert_test_suite_setup RSPEC_SETUP
    end
    
  end
end