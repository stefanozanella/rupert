require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'

require 'rupture'
require 'rupture/errors'

# Returns the absolute path for the given fixture filename, or the path of
# fixture directory if no argument present.
def fixture(filename='')
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end
