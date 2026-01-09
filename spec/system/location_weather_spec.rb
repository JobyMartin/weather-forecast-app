require "rails_helper"

RSpec.describe "Viewing a location without coordinates", type: :system do
  before { driven_by(:rack_test) } # run without selenium due to more SSL errors
  it "shows a flash alert and does not crash" do
    location = Location.create!(name: "Nowhereville", latitude: nil, longitude: nil)

    visit location_path(location)

    expect(page).to have_content("Weather data is unavailable for this location")
    expect(page).to have_content("7 Day Forecast for Nowhereville")
  end
end
