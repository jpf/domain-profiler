# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profiler/whois-orgname'

describe Whois do
  before (:all) do
    @whois = WhoisOrgName.new('4.2.2.2', false)
  end

  it "is fetching information from ARIN" do
    rv = @whois.grep('ARIN WHOIS')
    rv.should == '# ARIN WHOIS data and services are subject to the Terms of Use'
  end

 end
