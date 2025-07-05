class ColumnsController < ApplicationController
  before_action :set_board
  before_action :set_column, only: [ :show, :edit, :update, :destroy ]

  def index
    @columns = @board.columns
  end

  def show; end

  def new
    @column = @board.columns.build
  end

  def edit; end

  def create
    @column = @board.columns.build(column_params)

    if @column.save
      redirect_to @board, notice: "Coluna criada com sucesso."
    else
      render :new
    end
  end

  def update
    if @column.update(column_params)
      redirect_to @board, notice: "Coluna atualizada com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @column.destroy
    redirect_to @board, notice: "Coluna excluída com sucesso."
  end

  private

  def set_board
    @board = current_user.boards.find(params[:board_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to boards_path, alert: "Board não encontrado ou acesso negado."
  end

  def set_column
    @column = @board.columns.find(params[:id])
  end

  def column_params
    params.require(:column).permit(:name, :position)
  end
end
