class ChangePriorityTypeToStringInTasks < ActiveRecord::Migration[8.0]
  def up
    change_column :tasks, :priority, :string
  end

  def down
    change_column :tasks, :priority, :integer
  end
end
