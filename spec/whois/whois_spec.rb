# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profile/whois'

describe Whois do

  it "knows the name of the registrar" do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/whois.raw.dump')
    data = `cat #{filename}`
    whois = Whois.new
    whois.parse(data)
    whois.registrar.should == 'NETWORK SOLUTIONS, LLC.'
  end

  it "is able to deal with no data" do
    whois = Whois.new
    whois.registrar.should == 'Unknown'
  end

  it "is able to deal with nil input" do
    whois = Whois.new
    whois.parse(nil)
    whois.registrar.should == 'Unknown'
  end

  it "is able to deal with empty string input" do
    whois = Whois.new
    whois.parse('')
    whois.registrar.should == 'Unknown'
  end

end
