[![Build Status](https://travis-ci.org/stefanozanella/rupture.png?branch=master)](https://travis-ci.org/stefanozanella/rupture)
[![Code Climate](https://codeclimate.com/github/stefanozanella/rupture.png)](https://codeclimate.com/github/stefanozanella/rupture)
[![Coverage Status](https://coveralls.io/repos/stefanozanella/rupture/badge.png?branch=master)](https://coveralls.io/r/stefanozanella/rupture?branch=master)
[![Dependency Status](https://gemnasium.com/stefanozanella/rupture.png)](https://gemnasium.com/stefanozanella/rupture)

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

You can read an RPM simply with:

    rpm = Rupert::RPM.load('rpm-4.8.0-32.el6.x86_64.rpm')

or just check if a specific file is an RPM with:

    Rupert::RPM.rpm? 'iamtrollingyou' # false

(note that loading a file that is not an RPM generates an exception)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
