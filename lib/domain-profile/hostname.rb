class Hostname
  def shorten(input)
    host = input.split('.')
    host.shift if host.size > 2
    host.join('.')
  end
  def simplify(input,match=nil)
    lookup = {
      '1and1.com' => '1and1',
      'akam.net' => 'akami',
      'amazon.com' => 'amazon',
      'domaincontrol.com' => 'godaddy',
      'easydns.com' => 'easydns',
      'easydns.net' => 'easydns',
      'easydns.org' => 'easydns',
      'emailsrvr.com' => 'enom',
      'gandi.net' => 'gandi',
      'godaddy.com' => 'godaddy',
      'google.com' => 'google',
      'googlemail.com' => 'google',
      'mailhop.org' => 'dyninc',
      'messagingengine.com' => 'enom',
      'mydyndns.org' => 'dyninc',
      'name-services.com' => 'enom',
      'nettica.com' => 'nettica',
      'pair.com' => 'pair',
      'rackspace.com' => 'rackspace',
      'registrar-servers.com' => 'enom',
      'secureserver.net' => 'godaddy',
      'softlayer.com' => 'softlayer',
      'ultradns.info' => 'ultradns',
      'ultradns.net' => 'ultradns',
      'ultradns.org' => 'ultradns',
    }

    return '' if (not defined? input) or input.nil?
    return 'self' if (match and simplify(input) == simplify(match))
    return lookup[input.downcase] if lookup[input.downcase]
    input
  end
end
