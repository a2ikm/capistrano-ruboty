# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/ruboty/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-ruboty"
  spec.version       = Capistrano::Ruboty::VERSION
  spec.authors       = ["Masato Ikeda"]
  spec.email         = ["masato.ikeda@gmail.com"]

  spec.summary       = %q{Ruboty specific capistrano tasks}
  spec.description   = %q{Ruboty specific capistrano tasks}
  spec.homepage      = "https://github.com/a2ikm/capistrano-ruboty"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "capistrano", ">= 3.0"
  spec.add_runtime_dependency "ruboty", ">= 1.3"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
