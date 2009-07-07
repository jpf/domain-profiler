
class DNSType
  def initialize(input)
    @input = input
  end
  def method_missing(type)
    @input.map { |a| a[type] }.sort
  end
end

class DNSQuery
  def initialize(input)
    lookup = [:query,:ttl,:cl,:type,:answer]
    @query = input.grep(/^[^;]/).map do |line|
      Hash[*lookup.zip(line.gsub("\t\t","\t").split("\t")).flatten]
    end
  end
  def method_missing(type)
    rv = @query.map { |record| if record[:type] == type.to_s.upcase; record; else; nil; end }.compact
    DNSType.new(rv)
  end
end

class DNS
  def parse(data)
    @data = data.split("\n")
  end
  def method_missing(type)
    query = DNSQuery.new(@data)
    query.send(type)
  end
end
