# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profile/dns'
require 'domain-profile/whois'
require 'domain-profile/ssl'
require 'domain-profile/hostname'
require 'domain-profile/information'

#TODO: Abstract this.
def seconds_to_english(seconds)
#  return seconds unless seconds.to_i.is_a? Integer
  time = [[:year,31556926], [:month,2629743], [:week,604800], [:day,86400], [:hour,3600], [:minute,60], [:second,1]]
  seconds = seconds.to_i
  out = []
  time.each { |period,length|
    count = seconds / length
    if count > 0
      seconds -= count * length

      string = "#{count} #{period.to_s}"
      string << 's' if count > 1
      out.push(string)
    end
  }
  out.join(', ')
end

def org(uri)
  `./geoiplookup -f GeoIPOrg.dat #{uri}`.gsub("\n",'').split(': ')[1]
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
    self.map{|name| Hostname.new.simplify(name,host) }.uniq.sort
  end
end

print "-\n"
print " host=#{host}\n"
print "serve="
pp dns.a.map{|record| org(record.answer) }.lookup(host)
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
