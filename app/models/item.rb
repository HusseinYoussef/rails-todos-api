class Item < ApplicationRecord
  # model association
  belongs_to :todo, counter_cache: true

  # validation
  validates_presence_of :name
end
