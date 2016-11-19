class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :winner_id, type: BSON::ObjectId

  belongs_to :x_player, class_name: 'Player', inverse_of: :x_games
  belongs_to :o_player, class_name: 'Player', inverse_of: :o_games

  embeds_many :rounds

  def winner
    Player.find(self.winner_id)
  end
end
