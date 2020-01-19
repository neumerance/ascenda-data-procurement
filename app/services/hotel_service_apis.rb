#
class HotelServiceApis
  include HTTParty
  base_uri 'https://api.myjson.com'

  def hotel_a
    request('/bins/j6kzm')
  end

  def hotel_b
    request('/bins/1fva3m')
  end

  def hotel_c
    request('/bins/gdmqa')
  end

  private

  def request(path)
    response = self.class.get(path)
    if response.success?
      response.parsed_response
    else
      raise 'service can not be reach'
    end
  end
end
