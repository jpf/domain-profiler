# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profile/dns'

describe DNS do
  before(:all) do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/dns.raw.dump')
    data = `cat #{filename}`
    @dns = DNS.new
    @dns.parse(data)
  end

  it "knows what the 'answer' is for the SOA record" do
    @dns.soa.answer.should == ["ns1.zombo.com. ooaahh.yahoo.com. 2008111600 86400 7200 3600000 86400"]
  end

  it "knows what the 'answer' is for the NS record" do
    @dns.ns.answer.should == ["ns1.zombo.com.", "ns2.zombo.com."]
  end

  it "knows what the 'answer' is for the MX record" do
    @dns.mx.answer.should == ['0 zombo.com.']
  end

  it "knows what the 'answer' is for the A record" do
    @dns.a.answer.should == ['69.16.230.117']
  end

  it "knows what the TTL is for the A record" do
    @dns.a.ttl.should == ['10563']
  end

  it "knows what the query was for the A record" do
    @dns.a.query.should == ['zombo.com.']
  end

end
