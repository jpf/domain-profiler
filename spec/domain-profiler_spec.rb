# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
require 'domain-profiler'

describe DomainProfiler do

  it "has an orgname function that knows the orgname for 4.2.2.2" do
    orgname('4.2.2.2').should == 'Level 3 Communications'
  end

  it "has an orgname function that can handle nil as input" do
    orgname(nil).should == nil
  end

  it "has an orgname function that can handle an empty string ('') as input" do
    orgname('').should == ''
  end

  it "has an orgname function that can handle a symbol as input" do
    orgname(:monkey).should == :monkey
  end

end
