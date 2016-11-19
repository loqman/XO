class Round
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_move, type: String
  field :x_player_moves, type: Array
  field :o_player_moves, type: Array
  field :winner, type: String

  embedded_in :game
end
