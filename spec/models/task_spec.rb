require 'rails_helper'

RSpec.describe Task, type: :model do
  it "é válido com título, data, status e coluna" do
    user = User.create!(email: "teste@teste.com", password: "123456")
    board = Board.create!(name: "Projeto Exemplo", user: user)
    column = Column.create!(name: "To Do", board: board)

    task = Task.new(
      title: "Estudar RSpec",
      due_date: Date.tomorrow,
      status: "To Do",
      column: column
    )

    expect(task).to be_valid
  end
end
