
class Whois
  def parse(data)
    @data = data.split("\n")
  end
  def registrar
    @data.grep(/Registrar:/).to_s.split(': ')[1]
  end
end
