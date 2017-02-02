# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collate/version'

Gem::Specification.new do |spec|
  spec.name          = "collate"
  spec.version       = Collate::VERSION
  spec.authors       = ["Nicholas Page"]
  spec.email         = ["npage85@gmail.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/trackingboard/collate"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rails", "~> 4.2", ">= 4.2.6"
  spec.add_development_dependency "pg", "~> 0.18.4"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry-rescue", "~> 1.4", ">= 1.4.2"
  spec.add_development_dependency "simplecov", "~> 0.12.0"
  spec.add_development_dependency "httparty", "~> 0.12.0"
  spec.add_development_dependency "coveralls", "~> 0.8.15"
end
