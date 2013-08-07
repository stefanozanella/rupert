[![Gem Version](https://badge.fury.io/rb/rupert.png)](http://badge.fury.io/rb/rupert)
[![Build Status](https://travis-ci.org/stefanozanella/rupert.png?branch=master)](https://travis-ci.org/stefanozanella/rupert)
[![Code Climate](https://codeclimate.com/github/stefanozanella/rupert.png)](https://codeclimate.com/github/stefanozanella/rupert)
[![Coverage Status](https://coveralls.io/repos/stefanozanella/rupert/badge.png?branch=master)](https://coveralls.io/r/stefanozanella/rupert?branch=master)
[![Dependency Status](https://gemnasium.com/stefanozanella/rupert.png)](https://gemnasium.com/stefanozanella/rupert)

# Rupert

Pure Ruby RPM Library

## Installation

Add this line to your application's Gemfile:

    gem 'rupert'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rupert

## Usage

### Parsing an RPM

You can read an RPM simply with:

    rpm = Rupert::RPM.load('rpm-4.8.0-32.el6.x86_64.rpm')

or just check if a specific file is an RPM with:

    Rupert::RPM.rpm? 'iamtrollingyou' # false

(note that loading a file that is not an RPM generates an exception)

### Verifying RPM for corruption

You can verify if an RPM is corrupted after loading it with:

    rpm.intact?

Note that this only verifies if the MD5 stored in RPM metadata corresponds to
the MD5 calculated over the content and metadata itself. It doesn't provide any
warranty that the packages has been _maliciously_ altered. For this, you need
to check package _signature_.

### List of installed files

The list of installed files is returned as an array of absolute filenames with:

    rpm.filenames

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog

See [Changelog.md](Changelog.md)
