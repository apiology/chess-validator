# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chess-validator/version'

Gem::Specification.new do |spec|
  spec.name          = "chess-validator"
  spec.version       = ChessValidator::VERSION
  spec.authors       = ["Vince Broz"]
  spec.description   = %q{Command Line Tool for Validating Chess Moves}
  spec.summary       = %q{Command Line Tool for Validating Chess Moves}
  spec.license       = "GPL-3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "quality"
  spec.add_development_dependency "rspec", "3.0.0.beta1"
end
