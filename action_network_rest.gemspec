# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_network_rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'action_network_rest'
  spec.version       = ActionNetworkRest::VERSION
  spec.authors       = ['Grey Moore', 'Owens Ehimen', 'Diego Marcet']
  spec.email         = ['talk@controlshiftlabs.com']

  spec.summary       = 'Ruby client for interacting with the ActionNetwork REST API'
  spec.homepage      = 'https://github.com/controlshift/action-network-rest'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = ['>= 3.3', '< 5.0']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'faraday-mashify', '~> 1.0'
  spec.add_dependency 'vertebrae', '~> 1.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
