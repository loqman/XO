class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :winner_id, type: BSON::ObjectId
  field :in_progress, type: Boolean, default: true
  field :number_of_participants, type: Integer, default: 0
  field :public, type: Boolean, default: true

  belongs_to :x_player, class_name: 'Player', inverse_of: :x_games, optional: true
  belongs_to :o_player, class_name: 'Player', inverse_of: :o_games, optional: true

  embeds_many :rounds

  def winner
    Player.find(self.winner_id)
  end

  def is_playing(player)
    self.x_player == player || self.o_player == player
  end

  def play(player)
    if self.number_of_participants < 2
      self.o_player = player
      self.number_of_participants += 1
      self.save
    else
      false
    end
  end

  def player_shape(player)
    if self.x_player == player
      'x'
    else
      'o'
    end
  end

  def is_player_turn?(player)
    current_round = self.current_round
    if player_shape(player) == current_round.first_move
      current_round.moves.count.even?
    else
      current_round.moves.count.odd?
    end
  end

  def turn_shape
    current_round = self.current_round
    if current_round.moves.count.even?
      current_round.first_move
    else
      current_round.other_move
    end
  end

  def move!(player, col_num, row_num)
    self.current_round.move!(player_shape(player), col_num, row_num)
  end

  def x_player_winnings
    self.rounds.where(winner: 'x').count
  end

  def o_player_winnings
    self.rounds.where(winner: 'o').count
  end

  def check_for_winner
    if self.current_round.check_for_winner('x')
      self.declare_round_winner!('x')
    elsif self.current_round.check_for_winner('o')
      self.declare_round_winner!('o')
    else
      if self.current_round.moves.count == 9
        self.declare_round_draw!
      end
    end
  end

  def declare_round_winner!(shape)
    self.current_round.update({ winner: shape })
  end

  def declare_round_draw!
    self.current_round.update({ winner: 'draw' })
  end

  # private
  def current_round
    current_round = self.rounds.last
    if current_round.nil?
      current_round = self.rounds.new
      self.save
    end
    current_round
  end

  def new_round!
    if self.rounds.count.even?
      self.rounds.create! first_move: 'x'
    else
      self.rounds.create! first_move: 'o'
    end
  end
end
