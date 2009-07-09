
class DNSType
  def initialize(input)
    @input = input
  end
  # Helper for the :mx method
  def priority
    return '' unless @input[:type] == 'MX'
    @input[:answer].split(' ')[0]
  end
  # Helper for the :mx method
  def host
    return '' unless @input[:type] == 'MX'
    @input[:answer].split(' ')[1]
  end
  def method_missing(type)
    begin 
      @input[type] ||= ''
    rescue
      ''
    end
  end
end

class DNSQuery
  def initialize(input)
    @lookup = [:query,:ttl,:cl,:type,:answer]
    begin
      @query = input.grep(/^[^;]/).map do |line|
        Hash[*@lookup.zip(line.gsub("\t\t","\t").split("\t")).flatten]
      end
    rescue
      @query = Hash[]
    end

  end
  def spf
    rv = @query.map{|record|
      record if record[:type] == 'TXT'
    }.compact
    if rv.empty?
      [DNSType.new(nil)]
    else
      rv.map { |record| DNSType.new(record) }
    end
  end
  def method_missing(type)
    rv = @query.sort{|a,b| a[:answer] <=> b[:answer]}.map { |record| 
      record if record[:type] == type.to_s.upcase
    }.compact
    if rv.empty?
      [DNSType.new(nil)]
    else
      rv.map { |record| DNSType.new(record) }
    end
  end

end

class DNS
  def parse(data)
    begin
      @data = data.split("\n")
    rescue
      @data = Array.new()
    end
  end
  def method_missing(type)
    query = DNSQuery.new(@data)
    query.send(type)
  end
end
