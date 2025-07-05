class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy, :kanban]

  def index
    @boards = Board.all
    render "boards/boards"  # usa boards.html.erb
  end

  def show
    redirect_to kanban_board_path(@board)
  end

  def new
    @board = Board.new
    render "boards/create_board"  # usa create_board.html.erb
  end

  def create
    @board = Board.new(board_params)
    
    if @board.save
      create_default_columns
      redirect_to kanban_board_path(@board), notice: "Board criado com sucesso!"
    else
      render "boards/create_board"  # renderiza a mesma view com os erros
    end
  end

  def edit
    render "boards/create_board"  # se quiser usar o mesmo form da criação
  end

  def update
    if @board.update(board_params)
      redirect_to kanban_board_path(@board), notice: "Board atualizado com sucesso!"
    else
      render "boards/create_board"
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_path, notice: "Board deletado com sucesso!"
  end

def kanban
  @columns = @board.columns.includes(:tasks)

  @todo_column = @columns.find_by(name: "A Fazer")
  @in_progress_column = @columns.find_by(name: "Em Progresso")
  @done_column = @columns.find_by(name: "Concluído")

  @todo_tasks = @todo_column&.tasks || []
  @in_progress_tasks = @in_progress_column&.tasks || []
  @done_tasks = @done_column&.tasks || []

  render template: "todo_lists/index"
end


  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, :description)
  end

  def create_default_columns
    default_columns = ["A Fazer", "Em Progresso", "Concluído"]
    default_columns.each do |column_name|
      @board.columns.create!(name: column_name)
    end
  end
end
