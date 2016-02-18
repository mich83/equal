json.array!(@documents) do |document|
  json.extract! document, :title, :date, :content
  json.url document_url(document, format: :json)
end
