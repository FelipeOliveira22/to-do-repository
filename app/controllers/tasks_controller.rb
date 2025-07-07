class TasksController < ApplicationController
  before_action :set_board_and_column, except: [ :move_column ]
  before_action :set_task, only: [ :show, :edit, :update, :destroy, :complete ]

  def new
    @task = @column.tasks.build
  end

  def create
    @task = @column.tasks.new(task_params)
    @task.status = @column.name

    if @task.save
      if current_user.provider == "google_oauth2"
        GoogleCalendarService.new(current_user).create_or_update_event_for_task(@task)
      end

      redirect_to kanban_board_path(@board), notice: "Tarefa criada com sucesso!"
    else
      puts @task.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      if current_user.provider == "google_oauth2"
        GoogleCalendarService.new(current_user).create_or_update_event_for_task(@task)
      end
      redirect_to board_column_task_path(@board, @column, @task), notice: "Tarefa atualizada com sucesso!"
    else
      puts @task.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

def complete
  done_column = @board.columns.find_by(name: "Concluído")

  if done_column
    @task.update(
      done: true,
      column: done_column,
      status: "Concluído",
      updated_at: Time.current
    )
    redirect_to kanban_board_path(@board), notice: "Tarefa marcada como concluída!"
  else
    redirect_to kanban_board_path(@board), alert: "Coluna 'Concluído' não encontrada."
  end
end

  def destroy
    @task.destroy

    if current_user.provider == "google_oauth2" && @task.google_event_id.present?
      GoogleCalendarService.new(current_user).delete_event_for_task(@task)
    end

    redirect_to kanban_board_path(@board), notice: "Tarefa excluída com sucesso."
  end

  def move_column
    @task = current_user.boards.joins(columns: :tasks).where(tasks: { id: params[:id] }).first&.tasks&.find(params[:id])
    @target_column = current_user.boards.joins(:columns).where(columns: { id: params[:column_id] }).first&.columns&.find(params[:column_id])

    raise ActiveRecord::RecordNotFound unless @task && @target_column

    old_column = @task.column
    new_position = params[:position].to_i

    ActiveRecord::Base.transaction do
      if old_column != @target_column
        old_column.tasks.where("position > ?", @task.position).update_all("position = position - 1")
      end

      @target_column.tasks.where("position >= ?", new_position).where.not(id: @task.id).update_all("position = position + 1")

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
    @board = current_user.boards.find(params[:board_id])
    @column = @board.columns.find(params[:column_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to boards_path, alert: "Recurso não encontrado ou acesso negado."
  end

  def set_task
@task = Task.find(params[:id])
  end

  def task_params
    cleaned_params = params.require(:task).permit(:title, :due_date, :description, :priority, :done, :status)

    if cleaned_params[:priority].present?
      normalized = cleaned_params[:priority].downcase.strip

      cleaned_params[:priority] =
        case normalized
        when "low", "baixa" then "baixa"
        when "medium", "media", "média" then "media"
        when "high", "alta" then "alta"
        else nil
        end
    else
      cleaned_params[:priority] = nil
    end

    cleaned_params
  end
end
