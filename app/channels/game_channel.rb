# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_#{params[:game_id]}_channel"
    game = Game.find params[:game_id]
    game.current_round.moves.each do |move|
      # sleep 1
      ActionCable.server.broadcast "game_#{params['game_id']}_channel", shape: move.shape, col_num: move.col_num, row_num: move.row_num
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def play(data)
    game = Game.find data['game_id']
    current_player = Player.find data['player_id']
    if game.move!(current_player, data['col_num'], data['row_num'])
      ActionCable.server.broadcast "game_#{data['game_id']}_channel", shape: game.player_shape(current_player), col_num: data['col_num'], row_num: data['row_num']
    end
  end

  def replay(data)
    game = Game.find data['game_id']
    game.current_round.moves.each do |move|
      sleep 1
      ActionCable.server.broadcast "game_#{params['game_id']}_channel", shape: move.shape, col_num: move.col_num, row_num: move.row_num, replay: true
    end
  end

end

