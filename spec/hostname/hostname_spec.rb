# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profile/hostname'

describe Name do

  tests = {
    'dom'  => 'dom',
    'dom.' => 'dom',
    'example.dom'  => 'example.dom',
    'example.dom.' => 'example.dom',
    'www.example.dom' => 'example.dom',
    'www.example.dom' => 'example.dom',
    'ns1.example.dom' => 'example.dom',
    'ns2.example.dom' => 'example.dom',
    'ns1.ca.example.dom' => 'ca.example.dom',
  }.sort

  tests.each { |test|
    k = test[0]
    v = test[1]
    it "correctly shortens '#{k}'" do
      host = Name.new()
      host.shorten(k).should == v
    end
  }

  it "shortens easydns.com, easydns.net, easydns.org to 'easydns'" do
    host = Name.new()
    ["easydns.com", "easydns.net", "easydns.org"].each {|name|
      host.simplify(name).should == :easydns
    }
  end

  it "shortens EASYDNS.COM to 'easydns'" do
    host = Name.new()
    host.simplify('EASYDNS.COM').should == :easydns
  end

  it "shortens easydns.com to 'self' when the second option is 'easydns.net'" do
    host = Name.new()
    host.simplify('easydns.com','easydns.net').should == :self
  end

  it "shortens google.com to 'self' when the second option is 'google.com'" do
    host = Name.new()
    host.simplify('google.com','google.com').should == :self
  end

  it "correctly handles an empty string as input" do
    host = Name.new()
    host.simplify('').should == ''
  end

  it "correctly handles nil as input" do
    host = Name.new()
    host.simplify(nil).should == ''
  end

end
