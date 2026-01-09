require 'rails_helper'

RSpec.describe WeatherService do
  describe '.get_forecast' do
    latitude = 35.584
    longitude = -78.800

    let(:api_url) do
      "https://api.open-meteo.com/v1/forecast" \
      "?daily=temperature_2m_max,temperature_2m_min,weather_code" \
      "&latitude=#{latitude}" \
      "&longitude=#{longitude}" \
      "&precipitation_unit=inch" \
      "&temperature_unit=fahrenheit" \
      "&timezone=auto" \
      "&wind_speed_unit=mph"
    end

    response_forecast = {
        daily: {
          time: [
            "2026-01-09",
            "2026-01-10",
            "2026-01-11",
            "2026-01-12",
            "2026-01-13",
            "2026-01-14",
            "2026-01-15"
          ],
          temperature_2m_max: [ 68.6, 68.3, 62.2, 44.8, 52.1, 58.4, 45.9 ],
          temperature_2m_min: [ 43, 56.2, 32.9, 30.3, 32, 37.9, 23.3 ],
          weather_code: [ 0, 1, 2, 3, 61, 63, 80 ]
        }
      }.to_json

      # Stub the API request
      before do
        stub_request(:get, api_url)
          .to_return(status: 200, body: response_forecast)
      end
    it 'returns a 7 day forcast' do
      result = described_class.get_forecast(latitude, longitude)
      expect(result.length).to eq(7)
    end

    it "returns structured daily forecasts" do
      result = described_class.get_forecast(latitude, longitude)

      expect(result.first).to include(
        date: "2026-01-09",
        high: 68.6,
        low: 43,
        condition: be_a(String)
      )
    end
  end
end
