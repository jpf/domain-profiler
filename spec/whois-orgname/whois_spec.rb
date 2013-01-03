# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profiler/whois-orgname'

describe WhoisOrgName do
  before (:all) do
    @whois = WhoisOrgName.new('4.2.2.2', false)
  end

  it "is fetching information from ARIN" do
    rv = @whois.grep(/available at:/)
    rv.should == 'https://www.arin.net/whois_tou.html'
  end

 end
