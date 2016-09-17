class Item < ActiveRecord::Base
    include ActionView::Helpers::DateHelper
    
    def days_until_date
        distance_of_time_in_words(expiration, Date.today)
    end
    
end
