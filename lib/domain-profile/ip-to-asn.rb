
class Origin
  def initialize(ip_address)
    # dig +short 31.108.90.216.origin.asn.cymru.com TXT
    rip = ip_address.split('.').reverse.join('.')
    rv = `dig +short #{rip}.origin.asn.cymru.com TXT`
    @asn, @bgp_prefix, @country_code, @registry, @allocation_date = rv.chomp.gsub('"','').split(' | ')
  end
  attr_reader :asn, :bgp_prefix, :country_code, :registry, :allocation_date
end

class ASN
  def initialize(asn)
    rv = `dig +short AS#{asn}.asn.cymru.com TXT`
    @asn, @country_code, @registry, @allocation_date, @description = rv.chomp.gsub('"','').split(' | ')
  end
  def netname
    @description.match(/([^ ]+)/)[0]
  end
  def orgname
    @description.match(/.*? (- )?(.*)/)[2]
  end
  attr_reader :asn, :country_code, :registry, :allocation_date, :description
end

class IPtoASN
  def initialize(ip_address)
    version = 'v1'
    filename = "cache/ip-to-asn-#{ip_address}.#{version}.cache"
    @data = {}
    if File.exists?(filename)
      @data = open(filename) { |f| Marshal.load(f) }
    else
      @data[:origin] = Origin.new(ip_address)
      @data[:asn]    = ASN.new(@data[:origin].asn)
      open(filename, 'w') { |f| Marshal.dump(@data, f) }
    end
  end
  def origin
    @data[:origin]
  end
  def asn
    @data[:asn]
  end
end
