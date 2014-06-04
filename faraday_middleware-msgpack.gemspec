# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.add_dependency 'faraday_middleware', '>= 0.8.0'
  gem.add_dependency 'msgpack', '>= 0.4.7'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.6'

  gem.name          = "faraday_middleware-msgpack"
  gem.version       = "0.0.2"
  gem.authors       = ["Yuichi Tateno"]
  gem.email         = ["hotchpotch@gmail.com"]
  gem.description   = %q{faraday middleware msgpack}
  gem.summary       = %q{faraday middleware msgpack}
  gem.homepage      = "https://github.com/hotchpotch/faraday_middleware-msgpack"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
