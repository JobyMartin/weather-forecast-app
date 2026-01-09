require "net/http"
require "uri"
require "json"
require "openssl"

# class to handle API interactions and get the forecast for a certain location
class WeatherService
  # Hash containing conversions between weather code integers and string conditions
  WEATHER_CODES = {
    0 => "Clear",
    1 => "Mostly Clear",
    2 => "Partly Cloudy",
    3 => "Overcast",
    45 => "Fog",
    48 => "Icy Fog",
    51 => "Light Drizzle",
    53 => "Drizzle",
    55 => "Heavy Drizzle",
    56 => "Light Freezing Drizzle",
    57 => "Freezing Drizzle",
    80 => "Light Showers",
    81 => "Showers",
    82 => "Heavy Showers",
    85 => "Light Snow Showers",
    86 => "Snow Showers",
    61 => "Light Rain",
    63 => "Rain",
    65 => "Heavy Rain",
    66 => "Light Freezing Rain",
    67 => "Freezing Rain",
    71 => "Light Snow",
    73 => "Snow",
    75 => "Heavy Snow",
    77 => "Snow Grains",
    95 => "Thunderstorm",
    96 => "Light Thunderstorm w/ Hail",
    99 => "Thunderstorm w/ Hail"
  }

  # Method to get a 7-day weather forecast with highs, lows, and conditions using Open-Meteo API
  def self.get_forecast(latitude, longitude)
    url = URI("https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=auto&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    # Bypass SSL verification only in development due to SSL errors caused by local network protections
    if Rails.env.development?
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    weather_data = JSON.parse(response.body, symbolize_names: true)
    daily_weather_data = weather_data[:daily]

    # Format data
    daily_weather_data[:time].each_with_index.map do |date, index|
      {
        date: date,
        high: daily_weather_data[:temperature_2m_max][index],
        low: daily_weather_data[:temperature_2m_min][index],
        condition: WEATHER_CODES[daily_weather_data[:weather_code][index]]
      }
    end
  end
end
