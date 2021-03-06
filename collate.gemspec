# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collate/version'

Gem::Specification.new do |spec|
  spec.name          = "collate"
  spec.version       = Collate::VERSION
  spec.authors       = ["Nicholas Page", "Colleen McGuckin"]
  spec.email         = ["npage85@gmail.com", "colleenmcguckin@gmail.com"]

  spec.summary       = %q{Facilitates the filtering of ActiveRecord models using simplified DSL.}
  spec.description   = %q{Add some DSL to your model, then run a single method in your controller, and your model now accepts filtering through the parameters.}
  spec.homepage      = "https://github.com/trackingboard/collate"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|app/controllers|app/models|app/views/actors|app/views/movies|coverage|config|log)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",                  "~> 1.15.1"
  spec.add_development_dependency "rake",                     "~> 12.0.0"
  spec.add_development_dependency "rails",                    "~> 5.0.2"
  spec.add_development_dependency "single_test"
  spec.add_development_dependency "rails-controller-testing"
  spec.add_development_dependency "mysql2",                   "~> 0.4.5"
  spec.add_development_dependency "pg",                       "~> 0.20.0"
  spec.add_development_dependency "minitest",                 "~> 5.10.1", "< 5.10.2"
  spec.add_development_dependency "pry-rescue",               "~> 1.4.5"
  spec.add_development_dependency "simplecov",                "~> 0.14.1"
  spec.add_development_dependency "coveralls",                "~> 0.8.20"
  spec.add_development_dependency "haml",                     "~> 4.0.7"
end
