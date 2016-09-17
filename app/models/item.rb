class Item < ActiveRecord::Base
    include ActionView::Helpers::DateHelper

    def days_until_date
        distance_of_time_in_words(expiration, Date.today)
    end

    def color_of_days
    	rgb = [0, 0, 0]
    	if (expiration > Date.today)
    		if (expiration - Date.today > 14)
    			rgb[1] = 255
    		elsif (expiration - Date.today < 1)
    			rgb[0] = 255
    		else
    			rgb[1] = ((expiration - Date.today).to_i / 14) * 255
    			rgb[0] = ((14 - (expiration - Date.today).to_i) / 14) * 255
    		end
    	end
    end

end
