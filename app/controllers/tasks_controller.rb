class TasksController < ApplicationController
  before_action :set_board_and_column, only: [:new, :create, :show, :edit, :update, :destroy, :complete]
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete]

  def new
    @task = @column.tasks.build
  end

  def create
    @task = @column.tasks.new(task_params)
    @task.status = @column.name

    if @task.save
      redirect_to root_path, notice: "Tarefa criada com sucesso!"
    else
      puts @task.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @board, @column e @task já estão definidos pelos before_actions
  end

  def edit
    # @board, @column e @task já estão definidos pelos before_actions
  end

  def update
    if @task.update(task_params)
      redirect_to board_column_task_path(@board, @column, @task), 
                  notice: "Tarefa atualizada com sucesso!"
    else
      puts @task.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end
def complete
  if @task.update_column(:done, true)
    redirect_to board_column_task_path(@board, @column, @task),
                notice: "Tarefa marcada como concluída com sucesso!"
  else
    redirect_to board_column_task_path(@board, @column, @task),
                alert: "Erro ao concluir tarefa!"
  end
end
  def destroy
    @task.destroy
    redirect_to root_path, notice: "Tarefa excluída com sucesso."
  end

  private

  def set_board_and_column
    @board = Board.find(params[:board_id])
    @column = @board.columns.find(params[:column_id])
  end

  def set_task
    @task = @column.tasks.find(params[:id])
  end

  def move_column
    @task = Task.find(params[:id])
    new_column = Column.find(params[:column_id])

    @task.update(
      column: new_column,
      status: new_column.name
    )

    render json: { success: true }
  rescue => e
    render json: { success: false, error: e.message }
  end

  def task_params
    params.require(:task).permit(:title, :due_date, :description, :priority, :done, :status)
  end
end
