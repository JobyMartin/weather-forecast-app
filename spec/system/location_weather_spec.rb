require "rails_helper"

RSpec.describe "Viewing a location without coordinates", type: :system do
  before { driven_by(:rack_test) } # run without selenium due to more SSL errors
  it "shows a flash alert and does not crash" do
    location = Location.create!(name: "Nowhereville", latitude: nil, longitude: nil)

    visit location_path(location)

    expect(page).to have_content("Weather data is unavailable for this location")
    expect(page).to have_content("7 Day Forecast for Nowhereville")
  end

  it "shows an alert if a location cannot be geocoded" do
    # Stub the API call to return no results
    stub_request(:get, "https://geocoding-api.open-meteo.com/v1/search?count=1&format=json&language=en&name=Nowhereville")
      .to_return(status: 200, body: { results: [] }.to_json)

    visit new_location_path

    fill_in "Name", with: "Nowhereville"
    click_button "Create Location"

    expect(page).to have_content("Could not find coordinates for this location.")
  end
end
