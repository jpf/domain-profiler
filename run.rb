# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profile'
require 'erb'

profile = DomainProfile.new(ARGV[0])
puts ERB.new(File.read("view/text")).result
