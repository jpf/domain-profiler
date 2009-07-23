
class IPInfo
  def initialize(ip_address)
    # dig +short 31.108.90.216.origin.asn.cymru.com TXT
    rip = ip_address.split('.').reverse.join('.')
    rv = `dig +short #{rip}.origin.asn.cymru.com TXT`
    values = [:asn, :bgp_prefix, :prefix_country_code, :prefix_registry, :prefix_allocation_date]
    @lookup = Hash[*values.zip(rv.chomp.gsub('"','').split(' | ')).flatten]
  end
  def description
    as = ASNInfo.new(self.asn)
    as.description
  end
  def method_missing(type)
    @lookup[type.to_sym]
  end
end

class ASNInfo
  def initialize(asn)
    rv = `dig +short AS#{asn}.asn.cymru.com TXT`
    values = [:asn, :country_code, :registry, :allocation_date, :description]
    @lookup = Hash[*values.zip(rv.chomp.gsub('"','').split(' | ')).flatten]
  end
  def method_missing(type)
    @lookup[type.to_sym]
  end
end
