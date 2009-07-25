class Information
  def fetch(host)
    data = {}
    version = 'v2'
    filename = "cache/#{host}.#{version}.cache"
    if File.exists?(filename)
      data = open(filename) { |f| Marshal.load(f) }
    else
      data[:version] = version
      print "Fetching data for #{host}: DNS "
      $defout.flush
      data[:dns] = `server=4.2.2.2; host=#{host}; dig @$server ns $host; dig @$server a $host; dig @$server mx $host; dig @$server txt $host`
      print 'Whois '
      $defout.flush
      data[:whois] = `sleep 5; whois 'domain #{host}'`
      print 'SSL'
      $defout.flush
      data[:ssl] = `echo '' | openssl s_client -connect #{host}:443 2>&1`
      open(filename, "w") { |f| Marshal.dump(data, f) }
      print "\n"
      $defout.flush
    end
  end # fetch
end # Information
