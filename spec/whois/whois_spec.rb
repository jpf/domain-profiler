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

end
