# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profile'

def orgname(ip)
  ip = IPtoASN.new(ip)
  ip.asn.orgname
end

host = ARGV[0]
data = Information.new(:debug => true).fetch(host)

dns = DNS.new
dns.parse(data[:dns])
whois = Whois.new
whois.parse(data[:whois])
ssl = SSL.new
ssl.parse(data[:ssl])

class Array
  def lookup(host)
    self.map{|name| Hostname.new.simplify(name,host) }.uniq
  end
end

print "-\n"
print " host=#{host}\n"
print "serve="
pp dns.a.map{|record| orgname(record.answer) }.lookup(host)
print "  dns="
pp dns.ns.map{|record| Hostname.new.shorten(record.answer) }.lookup(host)
print " mail="
pp dns.mx.map{|record| Hostname.new.shorten(record.host) }.lookup(host)
print "whois="
pp whois.registrar.lookup(host)
print "  ssl="
pp ssl.ca.lookup(host)
print "sslcn="
pp ssl.cn
