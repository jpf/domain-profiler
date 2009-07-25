# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profiler/ssl'

describe SSL do
  before (:all) do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/openssl.raw.dump')
    data = `cat #{filename}`
    @ssl = SSL.new
    @ssl.parse(data)
  end

  it "knows the name of the certificate authority" do
    @ssl.ca.should == ['Thawte Consulting (Pty) Ltd.']
  end

  it "knows the common name on the certificate" do
    @ssl.cn.should == ['www.google.com']
  end

  it "knows when a certificate was issued/created" do
    @ssl.created.should == ['Mar 27 22:20:07 2009 GMT']
  end

  it "knows when a certificate expires" do
    @ssl.expires.should == ['Mar 27 22:20:07 2010 GMT']
  end

  it "knows the name of the certificate authority on a certificate with validation errors" do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/openssl.single.raw.dump')
    data = `cat #{filename}`
    ssl = SSL.new
    ssl.parse(data)
    ssl.ca.should == ['Thawte Consulting cc']
  end

  it "is able to deal with no data" do
    empty = SSL.new
    empty.ca.should == [:none]
    empty.cn.should == [:none]
    empty.expires.should == [:none]
  end

  it "is able to deal with an empty string as input" do
    empty = SSL.new
    empty.parse('')
    empty.ca.should == [:none]
    empty.cn.should == [:none]
    empty.expires.should == [:none]
  end

end
