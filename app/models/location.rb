class Location < ApplicationRecord
  before_validation :geocode_if_needed
  validate :ensure_geocoded

  private

  def geocode_if_needed
    return if latitude.present? && longitude.present?

    result = GeocodeService.geocoder(name)
    if result.present?
      self.latitude = result[:latitude]
      self.longitude = result[:longitude]
    end
  end

  def ensure_geocoded
    if latitude.blank? || longitude.blank?
      errors.add(:base, "Geocoding failed. Please enter latitude and longitude manually.")
    end
  end
end
