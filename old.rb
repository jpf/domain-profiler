#!/usr/bin/env ruby

require 'pp'
# require 'dnsruby'
# make README in markdown or a rdoc
# examples folder
# rdoc (rdoc.info)
# rspec
# license (MIT)
# jeweler (gem that makes gems)


#TODO: make this into a gem!
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


class DomainInfo
  def initialize(host)
    @host = host
    @whois = `sleep 0; whois #{host}`.split("\n")
    @dns = {}
    [:mx, :ns, :a, :txt].each { |type|
      @dns[type] = `dig #{host} -t #{type.to_s}`
    }
    @ssl = `echo '' | openssl s_client -connect #{host}:443 2>&1`
  end
  attr_accessor :whois, :dns, :ssl
end

class Domain
  def initialize(host)
    @host = host
    filename = "cache/cache-#{host}.cache"
    if File.exists?(filename)
      @info = open(filename) { |f| Marshal.load(f) }
    else
      @info = DomainInfo.new(host)
      open(filename, "w") { |f| Marshal.dump(@info, f) }
    end
  end
  def registrar
    self.info.whois.grep(/Registrar:/).to_s.split(': ')[1]
  end
  def mx
    method_missing(:mx).map { |rv|
      rv[:host] = Hostname.new(rv[:answer].split(' ')[1])
      rv
    }
  end
  #TODO: this really belongs in the Hostname class
  def ssl_issuer
    begin
      self.info.ssl.split("\n").grep(/^issuer=/).to_s.match(/O=([^\/]+)/)[1]
    rescue
      'none'
    end
  end
  def method_missing(type)
    lookup = [:query,:ttl,:cl,:type,:answer]
    h = Hash[]
    self.info.dns[type].split("\n").grep(/^[^;]/).map { |line|
      rv = Hash[*lookup.zip(line.gsub("\t\t","\t").split("\t")).flatten]
      rv[:host] = Hostname.new(rv[:answer])
      rv
    }
  end
  attr_accessor :host, :info
end

#TODO: abstract this
class Hostname
  def initialize(host)
    @host = host.to_s
  end
  def method_missing(type)
    @host
  end
  def sld
    @host.downcase.split('.')[-2..-1].join('.')
  end
  def ip
    `dig #{@host} a +short`.chomp
  end
  def org
    #TODO: Abstract this out to a whois class.
    filename = "cache/#{@host}.cache"
    if File.exists?(filename)
      whois = open(filename) { |f| Marshal.load(f) }
    else
      whois = `sleep 0; whois #{@host}`.split("\n")
      open(filename, "w") { |f| Marshal.dump(whois, f) }
    end

    begin
      whois.grep(/^OrgName:/).to_s.match(/OrgName:\s+(.*)/)[1]
    rescue
      `./geoiplookup -f GeoIPOrg.dat #{@host}`.chomp.split(': ')[1]
    end
  end
end  

class PaidFor
  def initialize(domain)
    @domain = domain
  end
  def registrar
    self.to_symbol(@domain.registrar)
  end
  def ssl_issuer
    self.to_symbol(@domain.ssl_issuer)
  end
  def hosting
    @domain.a.map {|rv| self.to_symbol(rv[:host].org) }.uniq
  end
  def dns_hosting
    @domain.ns.map { |rv| self.to_symbol(rv[:host].sld) }.uniq
  end
  def email_hosting
    @domain.mx.map { |rv| self.to_symbol(rv[:host].sld) }.uniq
  end
  def to_symbol(name)
  lookup = {
    '1 & 1 internet ag' => '1and1', # 2 
    '1and1.com' => '1and1', # 1 
    'akam.net' => 'akami', # 2 
    'akamai technologies' => 'akami', # 1 
    'amazon.com' => 'amazon', #13
    'amazon.com, inc.' => 'amazon',
    'comodo ca limited' => 'comodo', # 2 
    'digicert inc' => 'digicert', # 3 
    'domaincontrol.com' => 'godaddy', #11 
    'dotster, inc.   registrar' => '', # 2 
    'dstr acquisition pa i, llc dba domainbank.com   registrar' => '', # 1 
    'easydns technologies, inc.' => 'easydns', # 1 
    'easydns.com' => 'easydns', # 3 
    'easydns.org' => 'easydns', # 1 
    'emailsrvr.com' => 'enom', # 1 
    'enom, inc.' => 'enom', # 7 
    'enom, incorporated' => 'enom', # 1 
    'equifax secure inc.' => 'equifax', # 5 
    'gandi sas' => 'gandi', # 1 
    'gandi.net' => 'gandi', # 2 
    'godaddy.com' => 'godaddy', # 3 
    'godaddy.com, inc.' => 'godaddy', #59 
    'google.com' => 'google', #45 
    'googlemail.com' => 'google', #44 
    'mailhop.org' => 'dyninc', # 1 
    'messagingengine.com' => 'enom', # 2 
    'mydyndns.org' => 'dyninc', # 5 
    'name-services.com' => 'enom', # 2 
    'nettica.com' => 'nettica', # 3 
    'network solutions, llc.' => 'netsol', # 2 
    'pair networks' => 'pair', # 2 
    'pair.com' => 'pair', # 2 
    'rackspace.com' => 'rackspace', # 2 
    'registrar-servers.com' => 'enom', # 1 
    'secureserver.net' => 'godaddy', # 1 
    'slicehost llc' => 'slicehost', #13 
    'slicehost.net' => 'slicehost', #11 
    'softlayer corporate c' => 'softlayer', # 1 
    'softlayer technologies' => 'softlayer', # 1 
    'softlayer.com' => 'softlayer', # 5 
    'softlayer technologies inc.' => 'softlayer',
    'ultradns.info' => 'ultradns', # 1 
    'ultradns.net' => 'ultradns', # 1 
    'ultradns.org' => 'ultradns', # 1 
    'verisign trust network' => 'verisign', # 1 
    'verisign, inc.' => 'verisign', # 4 
    'wild west domains, inc.' => 'godaddy', #1 
  }

    return 'empty' unless (defined? name)
    return 'empty' if name.nil?
    lcname = name.downcase
    return 'self' if lcname == @domain.host
    return lookup[lcname] if lookup[lcname]
    name
  end
  def to_text
    self.public_methods(all=false).each { |name|
      next if name.match(/^to_/)
      print "#{name} = "
      pp self.send(name.intern)
    }
  end
  def to_text_simple
    self.public_methods(all=false).each { |name|
      next if name.match(/^to_/)
      print self.send(name.intern).to_a.join("\n")
    }
  end
end

class Decision
  def initialize(domain)
    @domain = domain
  end
  def spf
    @domain.txt.map { |record| record[:answer].gsub('"','').grep(/^v=spf/) }.flatten
  end
  def ttls
    rv = {}
    [:ns,:a,:mx,:txt].each { |type|
      rv[type] = @domain.send(type).map { |record| seconds_to_english(record[:ttl]) }.uniq
    }
    rv
  end
  def to_text
    self.public_methods(all=false).each { |name|
      next if name.match(/^to_/)
      print "#{name} = "
      pp self.send(name.intern)
    }
  end
end

host = Hostname.new(ARGV[0])
print "host = #{host.name}\n"
domain = Domain.new(host)
paidfor = PaidFor.new(domain)
decision = Decision.new(domain)
paidfor.to_text
decision.to_text
print "\n"
