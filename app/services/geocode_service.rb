require "net/http"
require "uri"
require "json"
require "openssl"

class GeocodeService
  def self.geocoder(address)
    url = URI("https://geocoding-api.open-meteo.com/v1/search?name=#{address}&count=1&language=en&format=json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    # Bypass SSL verification only in development due to SSL errors caused by local network protections
    if Rails.env.development?
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    parsed_data = JSON.parse(response.body, symbolize_names: true)
    location_results = parsed_data[:results].first
    # Return nil if there aren't results
    return nil unless location_results

    # Return only latitude and longitude
    {
      latitude: location_results[:latitude],
      longitude: location_results[:longitude]
    }
  end
end
