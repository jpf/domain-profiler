require 'ipaddr'
require 'domain-profiler/dns'
require 'domain-profiler/whois'
require 'domain-profiler/ssl'
require 'domain-profiler/name'
require 'domain-profiler/information'
require 'domain-profiler/ip-to-asn'
require 'yaml'

class DomainProfiler
  def initialize(host)
    @hostname = host
    data = Information.new(:debug => true).fetch(host)

    @dns = DNS.new
    @dns.parse(data[:dns])

    @whois = Whois.new
    @whois.parse(data[:whois])

    @ssl = SSL.new
    @ssl.parse(data[:ssl])
  end
  attr_reader :dns, :whois, :ssl, :hostname
end

def orgname(input)
  begin
    IPtoASN.new(input).asn.orgname
  rescue
    input
  end
end
