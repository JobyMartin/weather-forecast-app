require "rails_helper"

RSpec.describe "Viewing a location without coordinates", type: :system do
  before { driven_by(:rack_test) } # run without selenium due to more SSL errors

  it "shows an error and reveals latitude/longitude fields when a location cannot be geocoded" do
    # Stub the API call to return no results
    stub_request(:get, "https://geocoding-api.open-meteo.com/v1/search?count=1&format=json&language=en&name=Nowhereville")
      .to_return(status: 200, body: { results: [] }.to_json)

    visit new_location_path

    fill_in "Name", with: "Nowhereville"
    click_button "Create Location"

    # Error is displayed
    expect(page).to have_content('Geocoding failed. Please enter latitude and longitude manually.')

    # Lat/lon inputs are visible now
    expect(page).to have_field('Latitude')
    expect(page).to have_field('Longitude')
  end
end
