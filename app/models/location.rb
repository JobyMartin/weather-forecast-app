class Location < ApplicationRecord
  validate :must_be_geocoded

  private

  def must_be_geocoded
    return if latitude.present? && longitude.present?

    result = GeocodeService.geocoder(name)

    if result.nil?
      errors.add(:base, "Geocoding failed. Please enter latitude and longitude manually.")
    else
      self.latitude = result[:latitude]
      self.longitude = result[:longitude]
    end
  end
end
