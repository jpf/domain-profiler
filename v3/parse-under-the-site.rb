#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'pp'
require 'json'


ARGV.each {|arg|
  doc = Nokogiri::HTML(File.open(arg))
  rv = Hash.new()
  rv['name'] = doc.css("h1").text.strip
  rv['matcher'] = doc.css("code").text.strip
  puts "%s\t%s" % [rv['name'], rv['matcher']]
}