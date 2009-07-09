# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profile/ssl'

describe SSL do
  it "knows the name of the certificate authority" do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/openssl.raw.dump')
    data = `cat #{filename}`
    @ssl = SSL.new
    @ssl.parse(data)
    @ssl.ca.should == 'Thawte Consulting (Pty) Ltd.'
  end

  it "knows the name of the certificate authority on a certificate with validation errors" do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/openssl.single.raw.dump')
    data = `cat #{filename}`
    @ssl = SSL.new
    @ssl.parse(data)
    @ssl.ca.should == 'Thawte Consulting cc'
  end

  it "is able to deal with no data" do
    empty = SSL.new
    empty.ca.should == 'Unknown'
  end

end
