
class SSL
  def parse(data)
    @data = data.split("\n")
  end
  def ca
    @data.grep(/^ 1 s:/).to_s.match(/O=([^\/]+)\/[A-Z]/)[1]
  end
end
