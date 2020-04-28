require "bundler/setup"
require "action_network_rest"
require 'webmock/rspec'

# Require everything in the `support` directory
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each {|f| require f}

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Allow us to say 'describe Foo' instead of 'RSpec.describe Foo'
  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
