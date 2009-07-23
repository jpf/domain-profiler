
class Information
  def initialize(opt={})
    @debug = opt[:debug]
  end
  def status(message)
    return unless @debug
    $stderr.print message
    $stderr.flush
  end
  def fetch(host)
    data = {}
    #TODO: Automatically generate a 'version' - checksum this file or class?
    version = 'v2'
    filename = "cache/#{host}.#{version}.cache"
    if File.exists?(filename)
      data = open(filename) { |f| Marshal.load(f) }
    else
      data[:version] = version

      status "Fetching data for #{host}: DNS "
      data[:dns] = `server=4.2.2.2; host=#{host}; dig @$server ns $host; dig @$server a $host; dig @$server mx $host; dig @$server txt $host`

      status 'Whois '
      data[:whois] = `sleep 5; whois 'domain #{host}'`

      status 'SSL'
      data[:ssl] = `echo '' | openssl s_client -connect #{host}:443 2>&1`

      status ' ...'
      open(filename, "w") { |f| Marshal.dump(data, f) }

      status "\n"
      data
    end
  end # fetch
end # Information
