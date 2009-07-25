
class Whois
  def parse(data)
    @data = data.to_s.split("\n")
    # com = verisign
    # net = verisign
    # org = pir
    # info = afilias
  end
  def grep(pattern)
    begin
      @data.grep(pattern).to_s.split(':', 2)[1].strip ||= 'Unknown'
    rescue
      'Unknown'
    end
  end
  def registrar
    rv = grep(/Registrar:/)
    # cleanup pir and afilias type records
    rv.sub(/ \([^\)]+\)$/, '').to_a
  end
  def created
    grep(/Creat.+:/)
  end
  def updated
    grep(/Updated.+:/)
  end
  def expires
    grep(/Expiration Date:/)
  end
  def status
    grep(/Status:/)
  end
end
