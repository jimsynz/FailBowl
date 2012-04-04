# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fail_bowl/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Harton"]
  gem.email         = ["jamesotron@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fail_bowl"
  gem.require_paths = ["lib"]
  gem.version       = FailBowl::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
end
