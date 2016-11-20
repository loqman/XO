class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]


  def index
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new player_params
    respond_to do |format|
      if @player.save
        session[:player_id] = @player.id.to_s
        format.html { redirect_to game_index_path }
      else
        format.html { render :new }
      end
    end
  end

  def show
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
  def player_params
    params.require('player').permit :nickname
  end

  def set_player
    @player = Player.find params[:id]
  end
end
