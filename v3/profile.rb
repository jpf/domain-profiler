#!/usr/bin/env ruby

require 'rubygems'
require 'pp'

matchers = File.open('matchers')
regexes = Hash.new()
matchers.each {|line|
  (name,matcher) = line.split(/\t/)
  next unless matcher =~ /regex=/
  regex = matcher.sub(/^regex=/,'').strip
  regexes[regex] = name
}

# pp regexes

#data = IO.read('github')

site = ARGV[0]
data = `curl -Lisv #{site} 2>&1`

regexes.keys.each {|key|
  next if /\\$/.match(key)
  md = /#{key}/.match(data)
  next unless md

  #print "%s (%s): " % [regexes[key].sub(' matcher',''),key]
  puts regexes[key].sub(' matcher','')
  puts key
  pp md
  puts ''
}