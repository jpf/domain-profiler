class DNSType
  def initialize(input)
    @input = input
  end
  def mx_value(n)
    return :none unless (defined? @input[:type]) and @input[:type] == 'MX'
    @input[:answer].split(' ')[n]
  end
  # Helper for the :mx method
  def priority
    mx_value(0)
  end
  # Helper for the :mx method
  def host
    mx_value(1)
  end
  def method_missing(type)
    begin 
      @input[type] ||= :none
    rescue
      :none
    end
  end
end

class DNSQuery
  def initialize(input)
    @lookup = [:query,:ttl,:cl,:type,:answer]
    begin
      @query = input.grep(/^[^;]/).map do |line|
        tokenized = line.gsub(/\t+/,"\t").split("\t")
        Hash[*@lookup.zip(tokenized).flatten]
      end
    rescue
      @query = Hash[]
    end

  end
  def spf
    @query.map{|record|
      next unless record[:type] == 'TXT'
      txt = DNSType.new(record).answer.gsub('"','')
      next unless txt.match(/^v=spf/)
      txt
    }.compact

  end
  def method_missing(type)
    rv = @query.sort{|a,b| a[:answer].to_s <=> b[:answer].to_s}.map { |record| 
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
