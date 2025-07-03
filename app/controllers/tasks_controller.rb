class TasksController < ApplicationController
  def new
    @column = Column.find(params[:column_id])
    @board = @column.board  # <-- Adicionado
    @task = Task.new
    @columns = Column.all
  end

  def create
    @column = Column.find(params[:column_id])
    @board = @column.board  # <-- Adicionado
    @task = @column.tasks.new(task_params)
    @task.status = @column.name

    if @task.save
      redirect_to root_path, notice: "Tarefa criada com sucesso!"
    else
      puts @task.errors.full_messages
      @columns = Column.all
      render :new, status: :unprocessable_entity
    end
  end

    def destroy
      @task = Task.find(params[:id])
      @task.destroy

      redirect_to root_path, notice: "Tarefa excluída com sucesso."
    end

  private

  def task_params
    params.require(:task).permit(:title, :due_date, :description, :priority)
  end
end
