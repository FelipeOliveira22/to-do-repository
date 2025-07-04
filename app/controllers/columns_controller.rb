class ColumnsController < ApplicationController
  before_action :set_board
  before_action :set_column, only: [:show, :edit, :update, :destroy]

  # GET /boards/:board_id/columns
  def index
    @columns = @board.columns
  end

  # GET /boards/:board_id/columns/1
  def show
  end

  # GET /boards/:board_id/columns/new
  def new
    @column = @board.columns.build
  end

  # GET /boards/:board_id/columns/1/edit
  def edit
  end

  # POST /boards/:board_id/columns
  def create
    @column = @board.columns.build(column_params)

    if @column.save
      redirect_to @board, notice: "Column was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /boards/:board_id/columns/1
  def update
    if @column.update(column_params)
      redirect_to @board, notice: "Column was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /boards/:board_id/columns/1
  def destroy
    @column.destroy
    redirect_to @board, notice: "Column was successfully deleted."
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_column
    @column = @board.columns.find(params[:id])
  end

  def column_params
    params.require(:column).permit(:name, :position)
  end
end