class GameController < ApplicationController
  before_action :check_for_player

  def index
    @games = Game.where(in_progress: true, public: true).lte(number_of_participants: 1)
  end

  def game
    @game = Game.new
  end

  def new
    game = Game.new
    game.x_player = current_player
    game.number_of_participants = 1
    game.save
    redirect_to game_play_path(game)
  end

  def play
    @game = Game.find params[:id]
    session[:game_id] = @game.id.to_s
    respond_to do |format|
      if @game.is_playing(current_player)
        format.html
      else
        if @game.play(current_player)
          format.html
        else
          format.html { redirect_to game_error_full_path }
        end
      end
    end
  end

  def is_current_player_turn
    @game = Game.find params[:id]
    if @game.current_round.finished?
      render inline: 'finished'
    else
      if @game.is_player_turn?(current_player)
        render inline: 'true'
      else
        render inline: 'false'
      end
    end
  end

  def turn_shape
    @game = Game.find params[:id]
    render inline: "#{@game.turn_shape}"
  end

  def player_score
    @game = Game.find params[:id]
    if params[:shape] == 'x'
      render inline: @game.x_player_winnings.to_s
    else
      render inline: @game.o_player_winnings.to_s
    end
  end

  def check_for_winner
    @game = Game.find params[:id]
    @game.check_for_winner
    render inline: @game.current_round.winner
  end

  def new_round
    @game = Game.find params[:id]
    if @game.current_round.finished?
      @game.new_round!
      ActionCable.server.broadcast "game_#{params[:id]}_channel", new_round: true
      render inline: 'true'
    else
      render inline: 'false'
    end
  end

  private
  def check_for_player
    unless current_player
      redirect_to root_path
    end
  end

end
