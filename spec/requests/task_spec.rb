require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  let(:user) { create(:user) }
  let(:board) { create(:board, user: user) }
  let(:column) { create(:column, board: board) }

  let(:valid_attributes) {
    { title: "Nova tarefa", description: "Uma descrição", column_id: column.id }
  }

  let(:invalid_attributes) {
    { title: nil, description: "Sem título", column_id: column.id }
  }

  before { sign_in user }

  describe "POST /boards/:board_id/columns/:column_id/tasks" do
    context "com parâmetros válidos" do
      it "cria uma nova tarefa" do
        expect {
          post board_column_tasks_path(board, column),
               params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end
    end

    context "com parâmetros inválidos" do
      it "não cria tarefa" do
        expect {
          post board_column_tasks_path(board, column),
               params: { task: invalid_attributes }
        }.not_to change(Task, :count)
      end
    end
  end
end
