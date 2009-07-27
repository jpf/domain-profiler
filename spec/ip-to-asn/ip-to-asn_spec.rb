# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profiler/ip-to-asn'
require 'ipaddr'

describe IPtoASN do
  before(:all) do
    @use_cache = false
    @ip = IPtoASN.new('4.2.2.2',@use_cache)
  end

  ## Peer
  # BGP Origin ASN
  # BGP Peer ASN
  # BGP Prefix
  ## Origin
  # Prefix Country Code (assigned)
  # Prefix Registry (assigned)
  # Prefix Allocation date
  ## ASN
  # ASN Country Code (assigned)
  # ASN Registry (assigned)
  # ASN Allocation date
  # ASN Description

  # Origin
  # Peer
  # ASN

  it "knows the ASN" do 
    @ip.origin.asn.should == '3356'
  end

  it "knows the BGP Prefix" do 
    @ip.origin.bgp_prefix.should == '4.0.0.0/9'
  end

  it "knows the Prefix Country Code" do 
    @ip.origin.country_code.should == 'US'
  end

  it "knows the Prefix Registry" do 
    @ip.origin.registry.should == 'arin'
  end

  it "knows the Prefix Allocation date" do 
    @ip.origin.allocation_date.should == '1992-12-01'
  end

  it "knows the ASN description" do 
    @ip.asn.description.should == 'LEVEL3 Level 3 Communications'
  end

  it "knows the ASN NetName" do 
    @ip.asn.netname.should == 'LEVEL3'
  end

  it "knows the ASN OrgName" do 
    @ip.asn.orgname.should == 'Level 3 Communications'
  end

  it "can properly parse different types of ASN descriptions into OrgNames and NetNames" do 
    l3 = IPtoASN.new('4.2.2.2',@use_cache)
    l3.asn.orgname.should == 'Level 3 Communications'
    l3.asn.netname.should == 'LEVEL3'
    amz = IPtoASN.new('75.101.163.44',@use_cache)
    amz.asn.orgname.should == 'Amazon.com, Inc.'
    amz.asn.netname.should == 'AMAZON-AES'
  end

end
