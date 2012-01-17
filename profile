#!/usr/bin/env ruby
# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profiler'
require 'erb'

def help
  puts <<-help
Usage:
  $ ./profile domain.com
help
end

if ($stdin.tty? && ARGV.empty?) || ARGV.delete('-h') || ARGV.delete('--help')
  help
else
  profile = nil

  ARGV.each do |domain|
    profile = DomainProfiler.new(domain)
    puts ERB.new(File.read("view/text")).result
  end
end
