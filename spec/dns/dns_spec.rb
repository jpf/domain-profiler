# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profiler/dns'

describe DNS do
  before(:all) do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/dns.raw.dump')
    data = `cat #{filename}`
    @dns = DNS.new
    @dns.parse(data)
  end

  it "can return an SPF record" do
    @dns.spf[0].should == 'v=spf1 include:_netblocks.google.com ~all'
  end

  it "knows what the 'answer' is for the NS record" do
    @dns.ns[0].answer.should == 'ns1.google.com.'
  end

  it "knows what the 'answer' is for the MX record" do
    @dns.mx[0].answer.should == '10 smtp1.google.com.'
  end

  it "knows what the host part of the MX record is" do
    @dns.mx[0].host.should == 'smtp1.google.com.'
  end

  it "knows what the priority is for the MX record" do
    @dns.mx[0].priority.should == '10'
  end

  it "knows what the 'answer' is for the A record" do
    @dns.a[0].answer.should == '74.125.127.100'
  end

  it "knows what the TTL is for the A record" do
    @dns.a[0].ttl.should == '132'
  end

  it "knows what the query was for the A record" do
    @dns.a[0].query.should == 'google.com.'
  end

  it "DNSType is able to deal with empty input" do
    empty = DNSType.new('')
    empty.ttl.should == :none
  end

  it "DNSType is able to deal with nil input" do
    empty = DNSType.new(nil)
    empty.ttl.should == :none
  end

  it "DNSQuery is able to deal with empty input" do
    empty = DNSQuery.new('')
    empty.a.should.is_a?(DNSType) == true
  end

  it "DNSQuery is able to deal with nil input" do
    empty = DNSQuery.new(nil)
    empty.a.should.is_a?(DNSType) == true
  end

  it " is able to deal with empty input" do
    empty = DNS.new
    empty.parse('')
    empty.a[0].ttl.should == :none
  end

  it "is able to deal with nil input" do
    empty = DNS.new
    empty.parse(nil)
    empty.a[0].ttl.should == :none
  end

  it "is able to deal with missing MX records" do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/furbo.org.raw.dump')
    data = `cat #{filename}`
    @dns = DNS.new
    @dns.parse(data)
    @dns.mx[0].host.should == :none
  end
    
  it "is able to deal with data from go.com" do
    filename = File.expand_path(File.dirname(__FILE__) + '/fixtures/go.com.raw.dump')
    data = `cat #{filename}`
    @dns = DNS.new
    @dns.parse(data)
    @dns.a[0].answer.should == '198.105.193.70'
  end
    

end
