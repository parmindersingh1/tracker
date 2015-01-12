json.array!(@routes) do |route|
  json.extract! route, :id, :name, :start_time, :end_time, :vehicle_id
  json.url route_url(route, format: :json)
end
