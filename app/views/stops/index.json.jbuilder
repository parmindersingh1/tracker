json.array!(@stops) do |stop|
  json.extract! stop, :id, :name, :latitude, :longitude, :timeperiod, :sequence, :route_id
  json.url stop_url(stop, format: :json)
end
