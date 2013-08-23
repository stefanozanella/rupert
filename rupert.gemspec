# coding: utf-8
$:.unshift('lib') unless $:.include?('lib')
require 'pathname'
require 'rupert/version'

signing_key_file = ENV['RUBYGEMS_SIGNING_KEY_FILE']

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

  # Set local path to signing key with the RUBYGEMS_SIGNING_KEY_FILE env var.
  # To automate this setting, you may take a look at the `direnv` tool.
  spec.signing_key = Pathname.new(signing_key_file).expand_path if signing_key_file
  spec.cert_chain  = ["rubygems-stefanozanella.crt"]
end
