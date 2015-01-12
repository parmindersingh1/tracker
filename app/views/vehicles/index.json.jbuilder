json.array!(@vehicles) do |vehicle|
  json.extract! vehicle, :id, :registration_no, :capacity, :type
  json.url vehicle_url(vehicle, format: :json)
end
