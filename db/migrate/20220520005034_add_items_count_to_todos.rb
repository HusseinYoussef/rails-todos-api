class AddItemsCountToTodos < ActiveRecord::Migration[7.0]
  def change
    add_column :todos, :items_count, :integer, :default =>  0
  end
end
