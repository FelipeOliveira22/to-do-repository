class AddBoardToColumns < ActiveRecord::Migration[8.0]
  def change
    add_reference :columns, :board, foreign_key: true
  end
end
