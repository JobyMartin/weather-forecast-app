require "rails_helper"

RSpec.describe GeocodeService do
  describe ".geocoder" do
    address = 'Berlin'

    let(:api_url) do
      "https://geocoding-api.open-meteo.com/v1/search" \
      "?name=#{address}" \
      "&count=1" \
      "&language=en" \
      "&format=json"
    end

    let(:response_location) do
      {
        "results": [
          {
            "id": 2950159,
            "name": "Berlin",
            "latitude": 52.52437,
            "longitude": 13.41053,
            "elevation": 74.0,
            "feature_code": "PPLC",
            "country_code": "DE",
            "admin1_id": 2950157,
            "admin2_id": 0,
            "admin3_id": 6547383,
            "admin4_id": 6547539,
            "timezone": "Europe/Berlin",
            "population": 3426354,
            "postcodes": [
                "10967",
                "13347"
            ],
            "country_id": 2921044,
            "country": "Deutschland",
            "admin1": "Berlin",
            "admin2": "",
            "admin3": "Berlin, Stadt",
            "admin4": "Berlin"
          }
        ]
      }.to_json
    end

    before do
      stub_request(:get, api_url)
        .to_return(status: 200, body: response_location)
    end
    it "returns latitude and longitude" do
      result = described_class.geocoder(address)
      expect(result).to include(
        latitude: 52.52437,
        longitude: 13.41053
      )
    end

    it "returns nil if no geocoding results are found" do
      # Made up place to simulate an incorrect input
      address = "Nowhereville"

      stub_request(:get, /geocoding-api\.open-meteo\.com/)
        .with(query: hash_including("name" => address))
        .to_return(status: 200, body: { results: [] }.to_json)

      result = described_class.geocoder(address)

      expect(result).to be_nil
    end
  end
end
