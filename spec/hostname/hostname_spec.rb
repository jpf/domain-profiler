# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profile/hostname'

describe Hostname do

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
      host = Hostname.new()
      host.shorten(k).should == v
    end
  }

  it "shortens easydns.com, easydns.net, easydns.org to 'easydns'" do
    host = Hostname.new()
    ["easydns.com", "easydns.net", "easydns.org"].each {|name|
      host.simplify(name).should == :easydns
    }
  end

  it "shortens EASYDNS.COM to 'easydns'" do
    host = Hostname.new()
    host.simplify('EASYDNS.COM').should == :easydns
  end

  it "shortens easydns.com to 'self' when the second option is 'easydns.net'" do
    host = Hostname.new()
    host.simplify('easydns.com','easydns.net').should == :self
  end

  it "shortens google.com to 'self' when the second option is 'google.com'" do
    host = Hostname.new()
    host.simplify('google.com','google.com').should == :self
  end

  it "correctly handles an empty string as input" do
    host = Hostname.new()
    host.simplify('').should == ''
  end

  it "correctly handles nil as input" do
    host = Hostname.new()
    host.simplify(nil).should == ''
  end

#   it "knows how to simplify via regular expression" do
#     {
#       "com.s7a1.psmtp.com" => :postini,
#       "com.s7a2.psmtp.com" => :postini,
#       "com.s7b1.psmtp.com" => :postini,
#       "com.s7b2.psmtp.com" => :postini,
#     }.each { |input,output| 
#       host = Hostname.new()
#       host.simplify(input).should == output
#     }
#   end

end
