# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profile/dns'
require 'domain-profile/whois'
require 'domain-profile/ssl'
require 'domain-profile/hostname'

#TODO: Abstract this.
def seconds_to_english(seconds)
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

host = ARGV[0]

data = {}
filename = "cache/#{host}.v1.cache"
if File.exists?(filename)
  data = open(filename) { |f| Marshal.load(f) }
else
  data[:dns] = `server=4.2.2.2; host=#{host}; dig @$server ns $host; dig @$server a $host; dig @$server mx $host; dig @$server txt $host`
  data[:whois] = `whois #{host}`
  data[:ssl] = `echo '' | openssl s_client -connect #{host}:443 2>&1`
  open(filename, "w") { |f| Marshal.dump(data, f) }
end

def org(uri)
  `./geoiplookup -f GeoIPOrg.dat #{uri}`.gsub("\n",'').split(': ')[1]
end

dns = DNS.new
dns.parse(data[:dns])
whois = Whois.new
whois.parse(data[:whois])
ssl = SSL.new
ssl.parse(data[:ssl])

class Array
  def simplify(host)
    self.map{|name| Hostname.new.simplify(name,host) }.uniq.sort
  end
end

print "-\n"
print " host=#{host}\n"
print "serve="
pp dns.a.map{|record| org(record.answer) }
print "ttl a="
pp dns.a.map{|record| record.ttl }.uniq.map{|s| seconds_to_english(s)}.simplify(host)
print "  dns="
pp dns.ns.map{|record| Hostname.new.shorten(record.answer) }.simplify(host)
print "ttlns="
pp dns.ns.map{|record| record.ttl }.uniq.map{|s| seconds_to_english(s)}
print " mail="
pp dns.mx.map{|record| Hostname.new.shorten(record.host) }.simplify(host)
print "ttlmx="
pp dns.mx.map{|record| record.ttl }.uniq.map{|s| seconds_to_english(s)}
print "whois="
pp whois.registrar
print "  ssl="
pp ssl.ca
print "  spf="
pp dns.spf
