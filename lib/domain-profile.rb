require 'domain-profile/dns'
require 'domain-profile/whois'
require 'domain-profile/ssl'
require 'domain-profile/hostname'
require 'domain-profile/information'
require 'domain-profile/ip-to-asn'


class DomainProfile
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
