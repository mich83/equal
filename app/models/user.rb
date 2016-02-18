class User
  include Mongoid::Document
  field :name, type: String
  field :surname, type: String
  field :birthday, type: Date
end
