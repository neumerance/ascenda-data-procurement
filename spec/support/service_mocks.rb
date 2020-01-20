SERVICES = {
  a: 'j6kzm',
  b: '1fva3m',
  c: 'gdmqa'
}.freeze

def mock_hotel_service_apis
  SERVICES.each do |key, service|
    stub_request(:get, "https://api.myjson.com/bins/#{service}").
      to_return(
        status: 200,
        body: File.read(Rails.root.join("spec/fixtures/services/hotel_#{key}.json")),
        headers: { "Content-Type" => "application/json" }
      )
  end
end
