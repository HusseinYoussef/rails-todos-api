class AddTokenToTodos < ActiveRecord::Migration[7.0]
  def change
    add_column :todos, :token, :string
  end
end
