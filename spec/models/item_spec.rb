require 'rails_helper'

# Test suite for the Item model
RSpec.describe Item, type: :model do
  # Association
  # ensure an item record belongs to a single todo record
  it { should belong_to(:todo) }
  
  # Validations
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
end