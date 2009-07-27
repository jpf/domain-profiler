class Name
  def initialize
    @aliases = {
      :akami => { :name => 'Akamai', :dba => ['akam.net', 'akamai technologies'] },
      :amazon => { :name => 'Amazon.com', :dba => ['amazon.com', 'amazon.com, inc.'] },
      :comodo => { :name => 'Comodo Group', :dba => ['comodo ca limited','the usertrust network'] },
      :csc => { :name => 'Corporation Service Company', :dba => ['csc corporate domains, inc.'] },
      :digicert => { :name => 'DigiCert', :dba => ['digicert inc'] },
      :dyn_inc => { :name => 'Dyn Inc', :dba => ['mailhop.org', 'mydyndns.org','dynect.net'] }, 
      :easydns => { :name => 'easyDNS', :dba => ['easydns technologies, inc.', 'easydns.com', 'easydns.net', 'easydns.org'] },
      :enom => { :name => 'eNom', :dba => ['emailsrvr.com', 'enom, inc.', 'enom, incorporated', 'messagingengine.com', 'name-services.com', 'registrar-servers.com'] },
      :equifax => { :name => 'Equifax', :dba => ['equifax secure inc.','equifax'] },
      :gandi => { :name => 'Gandi SAS', :dba => ['gandi sas', 'gandi.net', 'dns.gandi.net'] },
      :godaddy => { :name => 'Go Daddy', :dba => ['domaincontrol.com', 'godaddy.com', 'godaddy.com, inc.', 'secureserver.net', 'wild west domains, inc.'] },
      :google => { :name => 'Google', :dba => ['aspmx.l.google.com', 'google.com', 'googlemail.com', 'l.google.com','google','google inc.'] },
      :iac => { :name => 'IAC Search and Media', :dba => ['iac search media inc'] },
      :markmonitor => { :name => 'MarkMonitor', :dba => ['markmonitor inc.'] },
      :microsoft => { :name => 'Microsoft', :dba => ['msft.net','microsoft corp'] },
      :netsol => { :name => 'Network Solutions', :dba => ['network solutions, llc.','network solutions llc','network solutions l.l.c.'] },
      :oneandone => { :name => '1 and 1', :dba => ['1 & 1 internet ag','1and1.com'] },
      :pair => { :name => 'pair Networks', :dba => ['pair networks', 'pair.com'] },
      :postini => { :name => 'Google (Postini)', :dba => ['psmtp.com'] },
      :rackspace => { :name => 'Rackspace', :dba => ['rackspace.com','rackspace.com, ltd.'] },
      :savis => { :name => 'Savvis', :dba => ['savvis','savvis.net'] },
      :serverbeach => { :name => 'ServerBeach', :dba => ['serverbeach'] },
      :slicehost => { :name => 'Slicehost', :dba => ['slicehost llc', 'slicehost.net'] },
      :softlayer => { :name => 'SoftLayer', :dba => ['softlayer corporate c', 'softlayer technologies inc.', 'softlayer technologies', 'softlayer.com'] },
      :thawte => { :name => 'thawte', :dba => ['thawte consulting cc','thawte consulting (pty) ltd.'] },
      :theplanet => { :name => 'The Planet', :dba => ['theplanet.com internet services','theplanet.com internet services, inc.'] },
      :tucows => { :name => 'Tucows', :dba => ['tucows inc.'] },
      :ultradns => { :name => 'Neustar (UltraDNS)', :dba => ['ultradns.info', 'ultradns.net', 'ultradns.org','ultradns.co.uk'] },
      :verisign => { :name => 'VeriSign', :dba => ['verisign trust network', 'verisign, inc.'] },
      :vzw_biz => { :name => 'Verizon (Cybertrust)', :dba => ['gte corporation'] },
      :yahoo => { :name => 'Yahoo!', :dba => ['yahoo.com','inktomi corporation'] },
    }

    @lookup = {}
    @aliases.keys.each {|shortname|
      @aliases[shortname][:dba].each {|dba|
        @lookup[dba] = shortname
      }
    }
  end
  def shorten(input)
    return input unless input.is_a? String
    return input unless input.match('.')

    host = input.split('.')
    # Return the second level domain if the top level domain name is com, net, or org.
    return "#{host[-2]}.#{host[-1]}" if host[-1].match(/(com|net|org)/)
    # Remove the leftmost subdomain if the domain name has a third level domain.
    host.shift if host.size > 2
    host.join('.')
  end
  def simplify(input,match=nil)
    return input unless input.is_a? String

    return :self if (match and simplify(input) == simplify(match))
    return @lookup[input.downcase] if @lookup[input.downcase]
    return :self if (match and simplify(input).gsub(/\W/,'').downcase.include? match.split(/\./)[-2])
    input
  end
  def full(shortname)
    return shortname unless shortname.is_a? Symbol
    return shortname unless @aliases[shortname].is_a? Hash

    @aliases[shortname][:name]
  end
end
