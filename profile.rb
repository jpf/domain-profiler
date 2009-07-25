# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profile'
require 'rubygems'
require 'gchart'

def orgname(ip)
  ip = IPtoASN.new(ip)
  ip.asn.orgname
end

class Array
  def lookup(host)
    self.map{|name| Hostname.new.simplify(name,host) }.uniq
  end
end


filename = ARGV[0]
file = File.new(filename)

hosts = file.map {|host|
  host.chomp!
  DomainProfile.new(host)
}

# Modify this to make stats on hosting provider, dns, mail, whois, ssl, ssn type and output HTML
hosts.each { |profile|
  host = profile.hostname
  print "-\n"
  print " host=#{host}\n"
  print "serve="
  pp profile.dns.a.map{|record| orgname(record.answer) }.lookup(host)
  print "  dns="
  pp profile.dns.ns.map{|record| Hostname.new.shorten(record.answer) }.lookup(host)
  print " mail="
  pp profile.dns.mx.map{|record| Hostname.new.shorten(record.host) }.lookup(host)
  print "whois="
  pp profile.whois.registrar.lookup(host)
  print "  ssl="
  pp profile.ssl.ca.lookup(host)
  print "sslcn="
  pp profile.ssl.cn
}

#output[:ssl_issuer] = output[:ssl_issuer].flatten.map{ |input| 
#  if input.is_a? String and input.match(/Unknown/) 
#    :none
#  else
#    input
#  end
#  }
#
#  puts "<html><body>"
#output.keys.each { |kind|
#  rv = output[kind].flatten.map { |i|
#    if i.is_a? Symbol
#      i
#    else
#      :other
#    end    
#  }
##   rv = output[kind].flatten.map
#  count = {}
#  rv.each { |provider|
#    begin
#      count[provider] += 1
#    rescue
#      count[provider] = 1
#    end
#  }
#  keys = []
#  values = []
#  count.sort { |a,b| a[1] <=> b[1] }.each { |k,v|
#    keys.push(k.to_s)
#    values.push(v)
#  }
#
#  gchart = Gchart.pie(:title => kind.to_s, :labels => keys, :data => values)

