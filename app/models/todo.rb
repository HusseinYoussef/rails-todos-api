class Todo < ApplicationRecord
  # model association
  has_many :items, dependent: :destroy

  has_secure_token
  # validations
  validates_presence_of :title, :created_by
end
