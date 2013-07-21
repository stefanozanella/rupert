require 'test_helper'

describe Rupture::RPM do
  let(:valid_rpm)   { fixture('rpm-4.8.0-32.el6.x86_64.rpm') }
  let(:invalid_rpm) { fixture('notanrpm-0.0.1-1.el6.noarch.rpm') }

  it "correctly loads a valid RPM" do
    Rupture::RPM.load(valid_rpm)
  end

  it "raises an error if the RPM is not in valid format" do
    proc {
      Rupture::RPM.load(invalid_rpm)
    }.must_raise Rupture::NotAnRPM
  end
end
