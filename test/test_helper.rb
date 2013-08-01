require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'minitest-spec-context'
require 'mocha/setup'

require 'rupture'
require 'rupture/errors'

# Returns the absolute path for the given fixture filename, or the path of
# fixture directory if no argument present.
def fixture(filename='')
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end

# Forces the string to be encoded as 8 bit ASCII (instead of, for example,
# UTF-8). This is to be used whenever a (binary) string is manually hardcoded
# in tests, since using a different encoding (e.g. UTF-8) breaks
# parsing/generating the IO stream.
def ascii(string)
  string.force_encoding(Encoding::ASCII_8BIT)
end

# Pads a string with nulls to fill given length
def pad(string, length)
  ("%-#{length}.#{length}s" % string).gsub(" ", "\x00")
end

# A string of nulls of given length
def null(length)
  pad("", length)
end

# Returns 128-bit MD5 checksum of given string
def md5(str)
  Digest::MD5.digest(str)
end

# Transforms given string into an IO object.
def io(string)
  StringIO.new(string)
end

# Helpers that builds a lead header from a plain string. Use it to make tests
# more readable.
def lead_from(string)
  Rupture::RPM::Lead.new(io(string))
end

def lead_with(string)
  lead_from(string)
end

# Helpers that builds a signature header from a plain string. Use it to make tests
# more readable.
def signature_from(string)
  Rupture::RPM::Signature.new(io(string))
end

def signature_with(string)
  signature_from(string)
end
