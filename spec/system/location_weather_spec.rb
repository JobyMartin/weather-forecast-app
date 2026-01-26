require "rails_helper"

RSpec.describe "Creating a location", type: :system do
  before { driven_by(:rack_test) } # run without selenium due to more SSL errors

  context "when geocoding fails" do
    it "shows an error and reveals latitude/longitude fields" do
      # Stub the API call to return no results
      stub_request(:get, "https://geocoding-api.open-meteo.com/v1/search?count=1&format=json&language=en&name=Nowhereville")
        .to_return(status: 200, body: { results: [] }.to_json)

      visit new_location_path

      fill_in "Name", with: "Nowhereville"
      click_button "Add Location"

      # Error is displayed
      expect(page).to have_content('Geocoding failed. Please enter latitude and longitude manually.')

      # Lat/lon inputs are visible now
      expect(page).to have_field('Latitude')
      expect(page).to have_field('Longitude')
    end
  end

  context "when geocoding succeeds" do
    let(:latitude) { 35.584 }
    let(:longitude) { -78.800 }

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

    let(:response_forecast) do
      {
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
    end

    # Stub the API request
    before do
      stub_request(:get, api_url)
        .to_return(status: 200, body: response_forecast)

      stub_request(:get, "https://geocoding-api.open-meteo.com/v1/search?count=1&format=json&language=en&name=Fuquay-Varina")
        .to_return(status: 200, body: { results: [ { latitude: 35.584, longitude: -78.800 } ] }.to_json)
    end
    it "successfully creates and renders a forecast with a chart" do
      visit new_location_path

      fill_in "Name", with: "Fuquay-Varina"
      click_button "Add Location"

      # Chech for correctly formatted title
      expect(page).to have_content('7 Day Forecast for Fuquay-Varina')

      # Check for 7 days in the forecast
      expect(page).to have_css("ul li", count: 7)

      # Check that the forecast information is being rendered correctly
      within("ul li", text: "2026-01-09") do
        expect(page).to have_content("Clear")
        expect(page).to have_content("69°F")
        expect(page).to have_content("43°F")
      end

      # Check if the chart is present
      expect(page).to have_css("img#forecast-chart")
    end
  end
end
