class AddDoneToTasks < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:tasks, :done)
      add_column :tasks, :done, :boolean, default: false, null: false
    end
  end
end
