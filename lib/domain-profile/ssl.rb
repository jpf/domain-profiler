require 'open3'

class SSL
  def parse(input)
    @data = {}
    output = []
    Open3.popen3('/usr/bin/openssl x509 -noout -dates -subject -issuer -email') { |stdin, stdout, stderr|
      stdin.puts(input)
      stdin.close
      output = stdout.readlines
    }
    output.each { |line| 
      (k,v) = line.gsub("\n", '').split(/=/,2).to_a.flatten
      @data[k] = v
    }
  end
  def cn
    begin
      @data['subject'].match(/CN=([^\/]+)/)[1]
    rescue
      'Unknown'
    end
  end
  def ca
    begin
      @data['issuer'].match(/O=([^\/]+)\/[A-Z]/)[1].to_a
    rescue
      'Unknown'.to_a
    end
  end
  def created
    begin
      @data['notBefore'] ||= 'Unknown'
    rescue
      'Unknown'
    end
  end
  def expires
    begin
      @data['notAfter'] ||= 'Unknown'
    rescue
      'Unknown'
    end
  end
end
