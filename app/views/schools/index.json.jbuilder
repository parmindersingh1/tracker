json.array!(@schools) do |school|
  json.extract! school, :id, :name, :address, :phone_no
  json.url school_url(school, format: :json)
end
