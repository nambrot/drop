json.array!(@locations) do |location|
  json.extract! location, :id, :lat, :lng, :user_id
  json.url location_url(location, format: :json)
end
