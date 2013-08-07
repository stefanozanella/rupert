# coding: utf-8
$:.unshift('lib') unless $:.include?('lib')
require 'rupert/version'

Gem::Specification.new do |spec|
  spec.name             = "rupert"
  spec.version          = Rupert::VERSION
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
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "flog"
  spec.add_development_dependency "flay"

  spec.description = %s{
    Rupert allows to manipulate RPM files independently from availability of rpmlib.
  }

  spec.signing_key = File.expand_path "~/.ssh/rubygems-stefanozanella.key"
  spec.cert_chain  = ["rubygems-stefanozanella.crt"]
end
