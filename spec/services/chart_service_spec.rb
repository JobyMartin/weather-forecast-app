require "rails_helper"

RSpec.describe ChartService do
  describe ".generate_chart_url" do
    it "returns a image chart url" do
      forecast = [
        { date: "2026-01-12", high: 38.4, low: 26.4 },
        { date: "2026-01-13", high: 41.2, low: 29.7 }
      ]
      url = described_class.generate_chart_url(forecast)

      expect(url).to include('image-charts.com')
      expect(url).to include('0:|2026-01-12|2026-01-13')
      expect(url).to include('t:38.4,41.2|26.4,29.7')
    end
  end
end
