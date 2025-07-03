class RenameDeadlineToDueDateInTasks < ActiveRecord::Migration[7.0]
  def change
    rename_column :tasks, :deadline, :due_date
  end
end
