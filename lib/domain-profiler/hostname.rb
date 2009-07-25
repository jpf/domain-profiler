class Name
  def initialize
    @aliases = {
      :akami => { :name => 'Akamai Technologies, Inc.', :dba => ['akam.net', 'akamai technologies'] },
      :amazon => { :name => 'Amazon.com, Inc.', :dba => ['amazon.com', 'amazon.com, inc.'] },
      :comodo => { :name => 'Comodo Group', :dba => ['comodo ca limited','the usertrust network'] },
      :csc => { :name => 'Corporation Service Company', :dba => ['csc corporate domains, inc.'] },
      :digicert => { :name => 'DigiCert, Inc.', :dba => ['digicert inc'] },
      :dyn_inc => { :name => 'Dynamic Network Services, Inc.', :dba => ['mailhop.org', 'mydyndns.org','dynect.net'] }, 
      :easydns => { :name => 'easyDNS Technologies, Inc.', :dba => ['easydns technologies, inc.', 'easydns.com', 'easydns.net', 'easydns.org'] },
      :enom => { :name => 'eNom, Inc.', :dba => ['emailsrvr.com', 'enom, inc.', 'enom, incorporated', 'messagingengine.com', 'name-services.com', 'registrar-servers.com'] },
      :equifax => { :name => 'Equifax, Inc.', :dba => ['equifax secure inc.','equifax'] },
      :gandi => { :name => 'Gandi SAS', :dba => ['gandi sas', 'gandi.net', 'dns.gandi.net'] },
      :godaddy => { :name => 'Go Daddy', :dba => ['domaincontrol.com', 'godaddy.com', 'godaddy.com, inc.', 'secureserver.net', 'wild west domains, inc.'] },
      :google => { :name => 'Google, Inc.', :dba => ['aspmx.l.google.com', 'google.com', 'googlemail.com', 'l.google.com','google'] },
      :markmonitor => { :name => 'MarkMonitor, Inc.', :dba => ['markmonitor inc.'] },
      :microsoft => { :name => 'Microsoft Corporation', :dba => ['msft.net'] },
      :netsol => { :name => 'Network Solutions, LLC', :dba => ['network solutions, llc.','network solutions llc'] }, # Network Solutions
      :none => { :name => 'none', :dba => ['none'] }, #FIXME: This cleans up after the DNS class
      :oneandone => { :name => '1 & 1 Internet, Inc.', :dba => ['1 & 1 internet ag','1and1.com'] },
      :pair => { :name => 'pair Networks, Inc.', :dba => ['pair networks', 'pair.com'] },
      :postini => { :name => 'Google, Inc. (Postini)', :dba => ['psmtp.com'] },
      :rackspace => { :name => 'Rackspace, Inc.', :dba => ['rackspace.com','rackspace.com, ltd.'] },
      :serverbeach => { :name => 'ServerBeach', :dba => ['serverbeach'] },
      :slicehost => { :name => 'Slicehost LLC', :dba => ['slicehost llc', 'slicehost.net'] },
      :softlayer => { :name => 'SoftLayer Technologies, Inc.', :dba => ['softlayer corporate c', 'softlayer technologies inc.', 'softlayer technologies', 'softlayer.com'] },
      :thawte => { :name => 'thawte, Inc.', :dba => ['thawte consulting cc','thawte consulting (pty) ltd.'] },
      :theplanet => { :name => 'The Planet Internet Services, Inc.', :dba => ['theplanet.com internet services','theplanet.com internet services, inc.'] },
      :tucows => { :name => 'Tucows, Inc.', :dba => ['tucows inc.'] },
      :ultradns => { :name => 'Neustar, Inc. (UltraDNS)', :dba => ['ultradns.info', 'ultradns.net', 'ultradns.org','ultradns.co.uk'] },
      :verisign => { :name => 'VeriSign', :dba => ['verisign trust network', 'verisign, inc.'] },
      :yahoo => { :name => 'Yahoo! Inc.', :dba => ['yahoo.com','inktomi corporation'] },
    }
  end
  def shorten(input)
    host = input.split('.')
    return "#{host[-2]}.#{host[-1]}" if host[-1].match(/(com|net|org)/)
    host.shift if host.size > 2
    host.join('.')
  end
  def simplify(input,match=nil)
    return '' if (not defined? input) or input.nil?
    return input unless input.is_a? String
    
    lookup = {}
    @aliases.keys.each {|shortname|
      @aliases[shortname][:dba].each {|dba|
        lookup[dba] = shortname
      }
    }

    return :self if (match and simplify(input) == simplify(match))
    return lookup[input.downcase] if lookup[input.downcase]
    return :self if (match and simplify(input).gsub(/\W/,'').downcase.include? match.split(/\./)[-2])
    input
  end
  def full(shortname)
    return shortname unless shortname.is_a? Symbol
    return shortname unless @aliases[shortname].is_a? Hash
    @aliases[shortname][:name]
  end
end
