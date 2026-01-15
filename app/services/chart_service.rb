
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
    chxs = "1,000000"

    # Find min and max temperature for proper chart rendering
    temps = highs + lows
    min_temp = temps.min
    max_temp = temps.max
    chds = "#{(min_temp - 5).round(0)},#{(max_temp + 5).round(0)}"
    chxr = "1,#{(min_temp - 5).round(0)},#{(max_temp + 5).round(0)}"

    # Return the final URL
    "#{base_url}?cht=lc&chs=700x300&chxt=x,y&chxl=#{chxl}&chd=#{chd}&chco=#{chco}&chg=14.28,20&chds=#{chds}&chxr=#{chxr}&chxs=#{chxs}"
  end
end
