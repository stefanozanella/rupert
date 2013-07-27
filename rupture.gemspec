# coding: utf-8
$:.unshift('lib') unless $:.include?('lib')
require 'rupture/version'

Gem::Specification.new do |spec|
  spec.name             = "rupture"
  spec.version          = Rupture::VERSION
  spec.authors          = ["Stefano Zanella"]
  spec.email            = ["zanella.stefano@gmail.com"]
  spec.summary          = %q{Pure Ruby RPM Library}
  spec.homepage         = ""
  spec.license          = "MIT"

  spec.files            = `git ls-files`.split($/)
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ["lib"]

  spec.extra_rdoc_files = ["README.md"]
  spec.rdoc_options     = ["--charset=UTF-8"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "minitest-spec-context"
  spec.add_development_dependency "mocha", "~> 0"

  spec.description = %s{
    Rupture allows to manipulate RPM files independently from availability of rpmlib.
  }
end
