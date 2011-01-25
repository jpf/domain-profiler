require 'open3'
# connect: Operation timed out
# connect: Connection refused
# connect:errno=61

class SSL
  def initialize
    @no_data = true
  end
  def parse(input)
    @data = {}
    output = []
    Open3.popen3('/usr/bin/openssl x509 -noout -dates -subject -issuer -email') { |stdin, stdout, stderr|
      stdin.puts(input)
      stdin.close
      output = stdout.readlines
    }
    output.each { |line| 
      (k,v) = [*line.gsub("\n", '').split(/\=/,2)].flatten
      @data[k] = v
      @no_data = false
    }
  end
  def cn
    return [:none] if @no_data
    [@data['subject'].match(/CN=([^\/]+)/)[1]]
  end
  def ca
    return [:none] if @no_data
    return [:none] unless @data.is_a? Hash
    begin
      [*@data['issuer'].match(/O=([^\/]+)\/[A-Z]/)[1]]
    rescue
      [:none]
    end
  end
  def created
    return [:none] if @no_data
    [@data['notBefore'] ||= :unknown]
  end
  def expires
    return [:none] if @no_data
    [@data['notAfter'] ||= :unknown]
  end
end
