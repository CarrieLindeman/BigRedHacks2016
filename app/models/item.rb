class Item < ActiveRecord::Base
    include ActionView::Helpers::DateHelper

    def days_until_date
        distance_of_time_in_words(expiration, Date.today)
    end

    def color
       maxColor = [0,0,255]
       minColor = [255,0,0]

       days = (expiration - Date.today).to_i
       score = calcScorePerc(days)

       r = calculateColor(maxColor[0], minColor[0], score)
       g = calculateColor(maxColor[1], minColor[1], score)
       b = calculateColor(maxColor[2], minColor[2], score)

       [r, g, b]
    end

    def calcScorePerc(score)
      normalized_score = (score < 0) ? 14 : score
      max = 14
      min = 0
      range = max - min
      ((normalized_score - min) * 100) / range
    end


    def calculateColor(max_color, min_color, day_percent)
       color_range = max_color - min_color
       score = (color_range < 0) ? (100 - day_percent) : day_percent
       additional_value = (color_range < 0) ? max_color : min_color
       (score * color_range.abs) / 100 + additional_value
    end

end
