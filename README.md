## What is domain-profiler?

domain-profiler is a tool that uses information from various sources (Whois, DNS, SSL, ASN) to determine what decisions have been made regarding a domain or list of domains.

These decisions fall into two categories:

1. Decisions that cost money.
    * Where the website is hosted.
    * Where DNS is hosted.
    * Where email is hosted.
    * The registrar of the domain.
    * Who issued the domain's SSL certificate (if anybody)
    * What sort of SSL certificate the domain has (if any)
2. Decisions that might or might not cost money.
    * Does the website use an image host like S3 or Imageshack?
    * Does the domain have SPF records? If so, what values?
    * What TTL do the DNS records have?
    * Expiration date for domain.
    * Expiration date for SSL certificate.
    * Is there more than one result for the A, MX, or NS records?
    * Are services hosted in different Autonomous Systems?
    * Are all services (A, MX, NS) in the same AS?
    * Does the main webpage have valid XHTML?
    * What type of frontend is the domain using?
    * What type of mailserver is the domain using?
    * Does the domain have a "*" record in DNS?
    * What sub-domains are dectable via HTTP 3xx redirects?
    * What sub-domains are dectable in the contents of '/'?

This version of domain-profiler only generates reports on the "Decisions that cost money".

## Setup and Examples

### Setup

The `./profile-list` command uses Google Charts, so you'll need to install [Matt Aimonetti's](https://github.com/mattetti) [googlecharts](https://github.com/mattetti/googlecharts) gem.

`gem install googlecharts`

### Example output from the `./profile` command:

    $ ./profile github.com
    Fetching data for github.com: DNS Whois SSL ...


    ==========[ github.com ]==========
    Web Hosting:
      (Rackspace)
          207.97.227.239

    DNS Hosting:
      (anchor.net.au)
          ns1.anchor.net.au.
          ns2.anchor.net.au.
      (EveryDNS.net)
          ns1.everydns.net.
          ns2.everydns.net.
          ns3.everydns.net.
          ns4.everydns.net.

    Email Hosting:
      (Google)
          1 ASPMX.L.GOOGLE.com.
          10 ASPMX2.GOOGLEMAIL.com.
          10 ASPMX3.GOOGLEMAIL.com.
          5 ALT1.ASPMX.L.GOOGLE.com.
          5 ALT2.ASPMX.L.GOOGLE.com.

    Domain Registrar:
      (Go Daddy)

    SSL Issuer:
      (GoDaddy.com, Inc.)
          Common Name: *.github.com

### Example output from the `./profile-list` command:

#### [Quantcast Top 100](http://jpf.github.com/domain-profiler/quantcast.html)

    ./profile-list quantcast 'Quantcast Top 100' > quantcast.html

Based on the output from the `profile-list` command, the Quantcast Top 100 domains appear to largely self host their websites, Email, and DNS. Interestingly, a large segment of these domains are registered with Mark Monitor or the Corporation Service Company, presumeably for the domain management and brand protection services that these companies provide. The domains with SSL certificates tend to have certificates issued by VeriSign.

#### [Y Combinator startups](http://jpf.github.com/domain-profiler/ycombinator.html)

      ./profile-list ycombinator 'Y Combinator startups' > ycombinator.html

Based on the output from the `profile-list` command, Y Combinator startups use a wide range of web hosts, but tend towards SoftLayer, Amazon, and Slicehost. If they aren't using Google Apps for Email hosting, they do it themselves. They generally do not host DNS themselves (much to my surprise - I expected to see a smaller list of DNS providers). They largely register their domains and get SSL certificates from GoDaddy, which I found surprising considering [GoDaddy's reputation](http://en.wikipedia.org/wiki/Go_Daddy#Controversies)
    
Thanks
======

* [Brian Lopez](http://github.com/brianmario) for help with Ruby and RSpec.
* Team Cymru for the awesome [IP to ASN API](http://www.team-cymru.org/Services/ip-to-asn.html).
* Hacker News user <a href="http://news.ycombinator.com/user?id=brett">brett</a> for the inspiration.
* [Jed Smith](http://jedsmith.org/) for the advice on using ARIN's WHOIS to find more accurate OrgName data on IP addresses.

LICENSE
=======

    (The MIT License)
    
    Copyright (c) 2009-2010 Joel Franusic <joel@franusic.com>
    
    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    'Software'), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:
    
    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.