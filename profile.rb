# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pp'
require 'domain-profile'
require 'rubygems'
require 'gchart'

def org(uri)
  `./geoiplookup -f GeoIPOrg.dat #{uri}`.gsub("\n",'').split(': ')[1]
end

class Array
  def lookup(host)
    self.map{|name| Hostname.new.simplify(name,host) }.uniq
  end
end


filename = ARGV[0]
hosts = File.new(filename)

output = {}
[:web_host,:dns_host,:mail_host,:registrar,:ssl_issuer,:ssl_type].each { |thing|
  output[thing] = Array.new()
}

hosts.each_line {|host|
  host.chomp!

  # !!
  # replace all this with DomainProfile.new(host)
  # !!
  data = Information.new(:debug => true).fetch(host)

  dns = DNS.new
  dns.parse(data[:dns])
  whois = Whois.new
  whois.parse(data[:whois])
  ssl = SSL.new
  ssl.parse(data[:ssl])

  output[:web_host].push(dns.a.map{|record| org(record.answer) }.lookup(host))
  output[:dns_host].push(dns.ns.map{|record| Hostname.new.shorten(record.answer) }.lookup(host))
  output[:mail_host].push(dns.mx.map{|record| Hostname.new.shorten(record.host) }.lookup(host))
  output[:registrar].push(whois.registrar.lookup(host))
  output[:ssl_issuer].push(ssl.ca.lookup(host))
  output[:ssl_type].push(ssl.cn)
}

output[:ssl_type] = output[:ssl_type].map { |input| 
  if input.is_a? Symbol
    input
  elsif input.match(/^\*/)
    :star
  elsif input.match('Unknown')
    :none
  else
    :normal
  end
}

output[:ssl_issuer] = output[:ssl_issuer].flatten.map{ |input| 
  if input.is_a? String and input.match(/Unknown/) 
    :none
  else
    input
  end
  }

  puts "<html><body>"
output.keys.each { |kind|
  rv = output[kind].flatten.map { |i|
    if i.is_a? Symbol
      i
    else
      :other
    end    
  }
#   rv = output[kind].flatten.map
  count = {}
  rv.each { |provider|
    begin
      count[provider] += 1
    rescue
      count[provider] = 1
    end
  }
  keys = []
  values = []
  count.sort { |a,b| a[1] <=> b[1] }.each { |k,v|
    keys.push(k.to_s)
    values.push(v)
  }

  gchart = Gchart.pie(:title => kind.to_s, :labels => keys, :data => values)
  puts "<img src='#{gchart}'/>"

}
  puts "</body></html>"
