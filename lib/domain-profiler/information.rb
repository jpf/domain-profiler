
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
    version = 'v4'
    dns_server = '208.67.222.222' # OpenDNS
#     dns_server = '4.2.2.2' # Level 3
    filename = "cache/#{host}.#{version}.cache"
    if File.exists?(filename)
      data = open(filename) { |f| Marshal.load(f) }
    else
      data[:version] = version

      status "Fetching data for #{host}: DNS "
      dnsopt = '+noadditional +noauthority'
      data[:dns] = `server=#{dns_server}; host=#{host}; dig @$server ns $host #{dnsopt}; dig @$server a $host #{dnsopt}; dig @$server mx $host #{dnsopt}; dig @$server txt $host #{dnsopt}`

      status 'Whois '
      data[:whois] = `sleep 2; whois 'domain #{host}'`

      status 'SSL'
      data[:ssl] = `echo '' | openssl s_client -connect #{host}:443 2>&1`

      status ' ...'
      open(filename, "w") { |f| Marshal.dump(data, f) }

      status "\n"
      data
    end
  end # fetch
end # Information
