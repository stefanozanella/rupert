[![Build Status](https://travis-ci.org/stefanozanella/rupture.png?branch=master)](https://travis-ci.org/stefanozanella/rupture)
[![Code Climate](https://codeclimate.com/github/stefanozanella/rupture.png)](https://codeclimate.com/github/stefanozanella/rupture)

# Rupture

Pure Ruby RPM Library

## Installation

Add this line to your application's Gemfile:

    gem 'rupture'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rupture

## Usage

You can read an RPM simply with:

    rpm = Rupture::RPM.load('rpm-4.8.0-32.el6.x86_64.rpm')

or just check if a specific file is an RPM with:

    Rupture::RPM.rpm? 'iamtrollingyou' # false

(note that loading a file that is not an RPM generates an exception)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
