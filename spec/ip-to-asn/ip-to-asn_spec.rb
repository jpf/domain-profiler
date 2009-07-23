# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'domain-profile/ip-to-asn'

describe IPInfo do
  before(:all) do
    @ip = IPInfo.new('4.2.2.2')
  end

  # BGP Origin ASN
  # BGP Peer ASN
  # BGP Prefix
  # Prefix Country Code (assigned)
  # Prefix Registry (assigned)
  # Prefix Allocation date
  # ASN Country Code (assigned)
  # ASN Registry (assigned)
  # ASN Allocation date
  # ASN Description

  it "knows the ASN" do 
    @ip.asn.should == '3356'
  end

  it "knows the BGP Prefix" do 
    @ip.bgp_prefix.should == '4.0.0.0/9'
  end

  it "knows the Prefix Country Code" do 
    @ip.prefix_country_code.should == 'US'
  end

  it "knows the Prefix Registry" do 
    @ip.prefix_registry.should == 'arin'
  end

  it "knows the Prefix Allocation date" do 
    @ip.prefix_allocation_date.should == '1992-12-01'
  end

  it "knows the ASN description" do 
    @ip.description.should == 'LEVEL3 Level 3 Communications'
  end

end
