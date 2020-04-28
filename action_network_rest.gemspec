
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "action_network_rest/version"

Gem::Specification.new do |spec|
  spec.name          = "action_network_rest"
  spec.version       = ActionNetworkRest::VERSION
  spec.authors       = ["Grey Moore"]
  spec.email         = ["grey@controlshiftlabs.com"]

  spec.summary       = "Ruby client for interacting with the ActionNetwork REST API"
  spec.homepage      = "https://github.com/controlshift/action-network-rest"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "vertebrae", "~> 0.6.0"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'webmock', '~> 3.8.3'
end
