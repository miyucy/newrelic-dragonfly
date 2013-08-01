# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic/dragonfly/version'

Gem::Specification.new do |spec|
  spec.name          = "newrelic-dragonfly"
  spec.version       = Newrelic::Dragonfly::VERSION
  spec.authors       = ["miyucy"]
  spec.email         = ["fistfvck@gmail.com"]
  spec.description   = %q{newrelic instrument for dragonfly}
  spec.summary       = %q{newrelic instrument for dragonfly}
  spec.homepage      = "https://github.com/miyucy/newrelic-dragonflyg"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "newrelic_rpm"
  spec.add_dependency "dragonfly"
end
