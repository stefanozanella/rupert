require 'test_helper'

describe Rupert::RPM do
  let(:valid_rpm)   { fixture('rpm-4.8.0-32.el6.x86_64.rpm') }
  let(:rpm)         { Rupert::RPM.load(valid_rpm) }

  it "reads the package checksum" do
    rpm.md5.must_equal "jvA7YQW9TICIGWjaSLF/sA=="
  end

  it "verifies package (non-cryptographic) integrity" do
    assert rpm.intact?, "expected package to be intact, but it was not."
  end
end
