# Thanks to HN user 'jedsmith' for telling me about this! (http://news.ycombinator.com/item?id=2081312)
class WhoisOrgName
  def initialize(input, use_cache = true)
    begin
      ip_address = IPAddr.new(input)
    rescue
      raise ArgumentError, "Input '#{input}' is invalid"
    end


    version = 'v2'
    filename = "cache/whois-orgname-#{ip_address}.#{version}.cache"
    @data = {}
    if File.exists?(filename) and use_cache
      @data = open(filename) { |f| Marshal.load(f) }
    else
      @data = `sleep 1; whois -h whois.arin.net 'n #{ip_address}'`
      open(filename, 'w') { |f| Marshal.dump(@data, f) } if use_cache
    end
  end

  def grep(pattern)
    begin
      @data.grep(pattern).to_s.split(':', 2)[1].strip ||= 'Unknown'
    rescue
      'Unknown'
    end
  end

  def orgname
    grep(/OrgName:/)
  end
end
