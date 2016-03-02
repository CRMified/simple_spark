# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spark_post/snap/version'

Gem::Specification.new do |spec|
  spec.name          = 'sparkpost-snap'
  spec.version       = SparkPost::Snap::VERSION
  spec.authors       = ['Jak Charlton']
  spec.email         = ['jakcharlton@gmail.com']
  spec.summary       = 'A library for accessing the SparkPost REST API http://www.sparkpost.com'
  spec.description   = 'An alternative to the official SparkPost Ruby gem'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec', '~> 0'
  spec.add_development_dependency 'rspec-nc', '~> 0'
  spec.add_development_dependency 'guard', '~> 0'
  spec.add_development_dependency 'guard-rspec', '~> 0'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'pry-remote', '~> 0'
  spec.add_development_dependency 'pry-nav', '~> 0'

  spec.add_dependency 'json', '>= 1.7.7', '< 2.0'
  spec.add_dependency 'excon', '>= 0.16.0', '< 1.0'
end
