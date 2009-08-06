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

This version of domain-profiler only generates reports on the "Decisions that cost money".

## Examples

### Example output from the 'profile' command:

<script src="http://gist.github.com/163180.js"></script>

### Example output from the 'profile-list' command:

1. [Quantcast Top 100](http://jpf.github.com/domain-profiler/quantcast.html)

    The Quantcast Top 100 domains appear to largely self host their websites, Email, and DNS.
    Interestingly, a large segment of these domains are registered with Mark Monitor or the Corporation Service Company, presumeably for the domain management and brand protection services that these companies provide.
    The domains with SSL certificates tend to have certificates issued by VeriSign.


2. [Y Combinator startups](http://jpf.github.com/domain-profiler/ycombinator.html)

    Y Combinator startups use a wide range of web hosts, but tend towards SoftLayer, Amazon, and Slicehost. If they aren't using Google Apps for Email hosting, they do it themselves. They generally do not host DNS themselves (much to my surprise - I expected to see a smaller list of DNS providers). They largely register their domains and get SSL certificates from GoDaddy, which I found surprising considering [GoDaddy's reputation](http://en.wikipedia.org/wiki/Go_Daddy#Controversies)
    
Thanks
======

* Brian Lopez for help with Ruby and RSpec.
* Team Cymru for the awesome IP to ASN API.
* Hacker News user <a href="http://news.ycombinator.com/user?id=brett">brett</a> for the inspiration.

LICENSE
=======

    (The MIT License)
    
    Copyright (c) 2009 Joel Franusic <joel@franusic.com>
    
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