
class SSL
  def parse(data)
    @data = data.split("\n")
  end
  def ca
    begin
      @data.grep(/^issuer=/).to_s.match(/O=([^\/]+)\/[A-Z]/)[1]
    rescue
      'Unknown'
    end
  end
end
