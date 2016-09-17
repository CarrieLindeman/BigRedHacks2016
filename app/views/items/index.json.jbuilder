json.array!(@items) do |item|
  json.extract! item, :id, :name, :expiration, :removed, :days_until_date, :color
  json.url item_url(item, format: :json)
end
