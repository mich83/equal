class Company
  include Mongoid::Document
  field :name, type: String
  field :address, type: String
  field :tax_id, type: String
  field :tel, type: String


end
