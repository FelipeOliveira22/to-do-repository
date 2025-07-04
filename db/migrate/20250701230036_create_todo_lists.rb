class CreateTodoLists < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_lists do |t|
      t.string :title
      t.string :subtitle
      t.string :color

      t.timestamps
    end
  end
end
