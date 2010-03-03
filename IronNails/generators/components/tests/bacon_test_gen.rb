module IronNails
  module BaconTestGen
    BACON_SETUP = <<-TEST


TEST

    def setup_test
      require_dependencies 'bacon', :group => :testing
      insert_into_gemfile 'caricature', :require => 'caricature', :group => :testing
      insert_test_suite_setup BACON_SETUP
    end
    
  end
end


