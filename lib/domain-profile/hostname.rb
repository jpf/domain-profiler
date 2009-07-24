class Hostname
  def shorten(input)
    host = input.split('.')
    return "#{host[-2]}.#{host[-1]}" if host[-1].match(/(com|net|org)/)
    host.shift if host.size > 2
    host.join('.')
  end
  def simplify(input,match=nil)
    # This should be replaced with regular expressions
    aliases = {
    :akami => ['akam.net', 'akamai technologies'],
    :amazon => ['amazon.com', 'amazon.com, inc.'],
    :comodo => ['comodo ca limited'], # Comodo Group
    :csc => ['csc corporate domains, inc.'], # Corporation Service Company
    :digicert => ['digicert inc'],
    :dyn_inc => ['mailhop.org', 'mydyndns.org','dynect.net'], 
    :easydns => ['easydns technologies, inc.', 'easydns.com', 'easydns.net', 'easydns.org'],
    :enom => ['emailsrvr.com', 'enom, inc.', 'enom, incorporated', 'messagingengine.com', 'name-services.com', 'registrar-servers.com'],
    :equifax => ['equifax secure inc.','equifax'],
    :gandi => ['gandi sas', 'gandi.net', 'dns.gandi.net'],
    :godaddy => ['domaincontrol.com', 'godaddy.com', 'godaddy.com, inc.', 'secureserver.net', 'wild west domains, inc.'],
    :google => ['aspmx.l.google.com', 'google.com', 'googlemail.com', 'l.google.com','google'],
    :markmonitor => ['markmonitor inc.'],
    :microsoft => ['msft.net'],
    :netsol => ['network solutions, llc.'], # Network Solutions
    #FIXME: This cleans up after the DNS class
    :none => ['none'],
    :oneandone => ['1 & 1 internet ag','1and1.com'],
    :pair => ['pair networks', 'pair.com'],
    :postini => ['psmtp.com'],
    :rackspace => ['rackspace.com','rackspace.com, ltd.'],
    :serverbeach => ['serverbeach'],
    :slicehost => ['slicehost llc', 'slicehost.net'],
    :softlayer => ['softlayer corporate c', 'softlayer technologies inc.', 'softlayer technologies', 'softlayer.com'],
    :thawte => ['thawte consulting cc','thawte consulting (pty) ltd.'],
    :theplanet => ['theplanet.com internet services','theplanet.com internet services, inc.'],
    :tucows => ['tucows inc.'],
    :ultradns => ['ultradns.info', 'ultradns.net', 'ultradns.org','ultradns.co.uk'],
    :verisign => ['verisign trust network', 'verisign, inc.'],
    :yahoo => ['yahoo.com','inktomi corporation'],
    }

    lookup = {}
    aliases.keys.each {|company|
      aliases[company].each {|dba|
        lookup[dba] = company
      }
    }

    return input unless input.is_a? String
    return '' if (not defined? input) or input.nil?
    return :self if (match and simplify(input) == simplify(match))
    return lookup[input.downcase] if lookup[input.downcase]
    return :self if (match and simplify(input).gsub(/\W/,'').downcase.include? match.split(/\./)[-2])
    input
  end
end
