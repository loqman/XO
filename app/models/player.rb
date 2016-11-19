class Player
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, type: String
  field :points, type: String

  has_many :x_games, class_name: 'Game', inverse_of: :x_player
  has_many :o_games, class_name: 'Game', inverse_of: :o_player

  def games
    self.x_games + self.o_games
  end

  def opponent(game)
    if game.x_player == self
      game.o_player
    else
      game.x_player
    end
  end
end
