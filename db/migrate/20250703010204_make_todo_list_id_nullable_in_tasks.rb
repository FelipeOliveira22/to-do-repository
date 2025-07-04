class MakeTodoListIdNullableInTasks < ActiveRecord::Migration[8.0]
  def change
        change_column_null :tasks, :todo_list_id, true
  end
end
