
class ChartService
  def self.generate_chart_url(forecast)
    dates = []
    highs = []
    lows = []

    # Loop through each day and extract the relevant data
    forecast.each do |day|
      dates << day[:date]
      highs << day[:high]
      lows << day[:low]
    end

    base_url = "https://image-charts.com/chart"
    chxl = "0:|#{dates.join('|')}"
    chd = "t:#{highs.join(',')}|#{lows.join(',')}"
    chco = "FF0000,0000FF"

    # Return the final URL
    "#{base_url}?cht=lc&chs=700x300&chxt=x,y&chxl=#{chxl}&chd=#{chd}&chco=#{chco}&chg=14.28,20"
  end
end
