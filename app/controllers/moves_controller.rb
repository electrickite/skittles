class MovesController < ApplicationController
  before_action :set_move, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :game
  load_and_authorize_resource through: :game, shallow: true

  # GET /moves
  # GET /moves.json
  def index
    @moves = @moves.includes(:player)
  end

  # GET /moves/1
  # GET /moves/1.json
  def show
  end

  # GET /moves/new
  def new
  end

  # GET /moves/1/edit
  def edit
  end

  # POST /moves
  # POST /moves.json
  def create
    respond_to do |format|
      if @move.save
        format.html { redirect_to @move, notice: 'Move was successfully created.' }
        format.json { render :show, status: :created, location: @move }
      else
        format.html { render :new }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moves/1
  # PATCH/PUT /moves/1.json
  def update
    respond_to do |format|
      if @move.update(move_params)
        format.html { redirect_to @move, notice: 'Move was successfully updated.' }
        format.json { render :show, status: :ok, location: @move }
      else
        format.html { render :edit }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moves/1
  # DELETE /moves/1.json
  def destroy
    @move.destroy
    respond_to do |format|
      format.html { redirect_to moves_url, notice: 'Move was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_move
    @move = Move.includes(:game, :player).find(params[:id])
  end

  def move_params
    params.require(:move).permit(:player_id, :notation)
  end
end
