
class Whois
  def parse(data)
    @data = data.to_s.split("\n")
  end
  def registrar
    begin
      @data.grep(/Registrar:/).to_s.split(': ')[1] ||= 'Unknown'
    rescue
      'Unknown'
    end
  end
end
