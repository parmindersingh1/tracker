json.array!(@devices) do |device|
  json.extract! device, :id, :mobile_no, :imei_no, :vehicle_id, :is_enabled
  json.url device_url(device, format: :json)
end
