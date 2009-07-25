# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profile'
require 'rubygems'
require 'gchart'
require 'erb'

def orgname(ip)
  ip = IPtoASN.new(ip)
  ip.asn.orgname
end

def fullname(name)
  Name.new.full(name)
end

class Array
  def lookup(host)
    self.map{|name| Name.new.simplify(name,host) }.uniq
  end
end


filename = ARGV[0]
file = File.new(filename)

hosts = {}

file.map {|host|
  host.chomp!
  profile = DomainProfile.new(host)

  out = {}
  out[:web_host]   = profile.dns.a.map{|record| orgname(record.answer) }.lookup(host)
  out[:dns_host]   = profile.dns.ns.map{|record| Name.new.shorten(record.answer) }.lookup(host)
  out[:mail_host]  = profile.dns.mx.map{|record| Name.new.shorten(record.host) }.lookup(host)
  out[:registrar]  = profile.whois.registrar.lookup(host)
  out[:ssl_issuer] = profile.ssl.ca.lookup(host)
  out[:ssl_type]   = [profile.ssl.cn]
  hosts[host] = out
}

# Modify this to make stats on hosting provider, dns, mail, whois, ssl, ssn type and count HTML

count = {}
types =  [:web_host,:mail_host,:dns_host,:registrar,:ssl_issuer,:ssl_type]

types.each { |kind| count[kind] = [] }

# Turn the list of host data into a hash of type data
hosts.each do |hostname,data|
  data.each do |kind,value|
    count[kind].push(value) unless kind == :ssl_type

    type = value[0]
    if type.is_a? Symbol
      ssl_type = type
    elsif type.match(/^\*/)
      ssl_type = :star
    else
      ssl_type = :normal
    end
    count[kind].push(ssl_type)

  end
end

output = {}
count.each do |kind,values|
  summary = {}
  values.flatten.each do |value|
    value = :other unless value.is_a? Symbol
      
    if summary[value].is_a? Integer
      summary[value] += 1
    else
      summary[value] = 1
    end
  end
  output[kind] = summary
end

# Collapse any item less than smallest_percent into the :other category
smallest_percent = 0.02  
output.each do |kind,values|
  total = 1
  values.each {|k,v| total += v}
  smallest_value = total * smallest_percent
  values.each {|k,v| 
    if v < smallest_value
      values[:other] += v
      values.delete(k)
    end
  }
end


output.each do |kind, summary_data|
  keys = []
  values = []
  summary_data.sort { |a,b| a[1] <=> b[1] }.each do |k,v|
    keys.push(k.to_s)
    values.push(v)
  end

  output[kind] = Gchart.pie(:title => kind.to_s, :labels => keys, :data => values) 
end

charts = output
puts ERB.new(File.read("view/html")).result
