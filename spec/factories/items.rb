FactoryBot.define do
    factory :item do
      name { Faker::Game.title }
      done {false}
      todo_id {nil}
    end
end