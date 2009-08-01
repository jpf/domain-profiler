class Name
  def initialize
    lookup_file = File.expand_path(File.dirname(__FILE__) + '../../../config/name-lookups.yaml')
    @aliases = YAML::load(File.open(lookup_file))
    @lookup = {}
    @aliases.keys.each {|shortname|
      next unless @aliases[shortname][:dba].is_a? Array
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
