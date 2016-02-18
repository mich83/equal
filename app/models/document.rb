class Document
  include Mongoid::Document
  field :title, type: String
  field :date, type: Time
  field :content, type: String
  field :styles, type: String
end
