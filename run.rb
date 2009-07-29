# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profiler'
require 'erb'

profile = DomainProfiler.new(ARGV[0])
name = Name.new
puts ERB.new(File.read("view/text")).result
