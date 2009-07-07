# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profile/ssl'

describe SSL do
  before(:all) do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/openssl.raw.dump')
    data = `cat #{filename}`
    @ssl = SSL.new
    @ssl.parse(data)
  end

  it "knows the name of the certificate authority" do
    @ssl.ca.should == 'Thawte Consulting (Pty) Ltd.'
  end

end
