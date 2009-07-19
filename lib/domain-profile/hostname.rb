class Hostname
  def shorten(input)
    host = input.split('.')
    host.shift if host.size > 2
    host.join('.')
  end
  def simplify(input,match=nil)
    aliases = {
    '1and1' => ['1 & 1 internet ag','1and1.com'],
    'akami' => ['akam.net', 'akamai technologies'],
    'amazon' => ['amazon.com', 'amazon.com, inc.'],
    'dyninc' => ['mailhop.org', 'mydyndns.org'],
    'easydns' => ['easydns technologies, inc.', 'easydns.com', 'easydns.net', 'easydns.org'],
    'enom' => ['emailsrvr.com', 'enom, inc.', 'enom, incorporated', 'messagingengine.com', 'name-services.com', 'registrar-servers.com'],
    'gandi' => ['gandi sas', 'gandi.net'],
    'godaddy' => ['domaincontrol.com', 'godaddy.com', 'godaddy.com, inc.', 'secureserver.net', 'wild west domains, inc.'],
    'google' => ['aspmx.l.google.com', 'google.com', 'googlemail.com', 'l.google.com'],
    'pair' => ['pair networks', 'pair.com'],
    'slicehost' => ['slicehost llc', 'slicehost.net'],
    'softlayer' => ['softlayer corporate c', 'softlayer technologies inc.', 'softlayer technologies', 'softlayer.com'],
    'ultradns' => ['ultradns.info', 'ultradns.net', 'ultradns.org'],
    'verisign' => ['verisign trust network', 'verisign, inc.'],
    }

    lookup = {}
    aliases.keys {|company|
      aliases.company.each {|dba|
        lookup[dba] = company
      }
    }


#     lookup = {
#     '1 & 1 internet ag' => '1and1',
#     '1and1.com' => '1and1',
#     'akam.net' => 'akami',
#     'akamai technologies' => 'akami',
#     'amazon.com' => 'amazon',
#     'amazon.com, inc.' => 'amazon',
#     'comodo ca limited' => 'comodo',
#     'digicert inc' => 'digicert',
#     'domaincontrol.com' => 'godaddy',
#     'easydns technologies, inc.' => 'easydns',
#     'easydns.com' => 'easydns',
#     'easydns.org' => 'easydns',
#     'easydns.net' => 'easydns',
#     'emailsrvr.com' => 'enom',
#     'enom, inc.' => 'enom',
#     'enom, incorporated' => 'enom',
#     'equifax secure inc.' => 'equifax',
#     'gandi sas' => 'gandi',
#     'gandi.net' => 'gandi',
#     'godaddy.com' => 'godaddy',
#     'godaddy.com, inc.' => 'godaddy',
#     'google.com' => 'google',
#     'googlemail.com' => 'google',
#       'aspmx.l.google.com' => 'google',
#       'l.google.com' => 'google',
#     'mailhop.org' => 'dyninc',
#     'messagingengine.com' => 'enom',
#     'mydyndns.org' => 'dyninc',
#     'name-services.com' => 'enom',
#     'nettica.com' => 'nettica',
#     'network solutions, llc.' => 'netsol',
#     'pair networks' => 'pair',
#     'pair.com' => 'pair',
#     'rackspace.com' => 'rackspace',
#     'registrar-servers.com' => 'enom',
#     'secureserver.net' => 'godaddy',
#     'slicehost llc' => 'slicehost',
#     'slicehost.net' => 'slicehost',
#     'softlayer corporate c' => 'softlayer',
#     'softlayer technologies' => 'softlayer',
#     'softlayer.com' => 'softlayer',
#     'softlayer technologies inc.' => 'softlayer',
#     'ultradns.info' => 'ultradns',
#     'ultradns.net' => 'ultradns',
#     'ultradns.org' => 'ultradns',
#     'verisign trust network' => 'verisign',
#     'verisign, inc.' => 'verisign',
#     'wild west domains, inc.' => 'godaddy',
#     }

    return '' if (not defined? input) or input.nil?
    return 'self' if (match and simplify(input) == simplify(match))
    return "> #{lookup[input.downcase]}" if lookup[input.downcase]
    input
  end
end
