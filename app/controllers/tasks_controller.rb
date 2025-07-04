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
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to board_column_task_path(@board, @column, @task), 
                  notice: "Tarefa atualizada com sucesso!"
    else
      puts "Erros da tarefa:"
      puts @task.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    if @task.update_columns(done: true, updated_at: Time.current)
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

  def move_column
    @task = Task.find(params[:id])
    @target_column = Column.find(params[:column_id])
    old_column = @task.column
    new_position = params[:position].to_i

    ActiveRecord::Base.transaction do
      if old_column != @target_column
        old_column.tasks.where('position > ?', @task.position)
                        .update_all('position = position - 1')
      end

      @target_column.tasks.where('position >= ?', new_position)
                          .where.not(id: @task.id)
                          .update_all('position = position + 1')

      @task.update!(
        column: @target_column, 
        position: new_position, 
        status: @target_column.name
      )
    end

    render json: { success: true }
  rescue => e
    puts "Erro ao mover a task: #{e.message}"
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_board_and_column
    @board = Board.find(params[:board_id])
    @column = @board.columns.find(params[:column_id])
  end

  def set_task
    @task = @column.tasks.find(params[:id])
  end

  def task_params
    cleaned_params = params.require(:task).permit(:title, :due_date, :description, :priority, :done, :status)

    if cleaned_params[:priority].present?
      case cleaned_params[:priority].downcase.strip
      when "low", "baixa"
        cleaned_params[:priority] = "baixa"
      when "medium", "média", "media"
        cleaned_params[:priority] = "media"
      when "high", "alta"
        cleaned_params[:priority] = "alta"
      else
        cleaned_params[:priority] = nil
      end
    else
      cleaned_params[:priority] = nil
    end
    cleaned_params
  end
end
