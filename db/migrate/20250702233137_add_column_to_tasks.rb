class AddColumnToTasks < ActiveRecord::Migration[8.0]
  def change
    add_reference :tasks, :column, foreign_key: true
  end
end
