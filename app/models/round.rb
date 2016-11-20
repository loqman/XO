class Round
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_move, type: String, default: 'x'
  field :winner, type: String, default: 'incomplete'

  embedded_in :game
  embeds_many :moves

  def other_move
    if self.first_move == 'x'
      'o'
    else
      'x'
    end
  end

  def move!(shape, col_num, row_num)
    if self.winner == 'incomplete'
      move = self.moves.where(col_num: col_num, row_num: row_num).first
      if move.nil?
        self.moves.create! shape: shape, col_num: col_num, row_num: row_num
      else
        false
      end
    else
      false
    end
  end

  def finished?
    self.winner != 'incomplete'
  end

  def x_player_moves
    self.moves.where(shape: 'x')
  end

  def o_player_moves
    self.moves.where(shape: 'o')
  end

  def check_for_winner(shape)
    winner_moves = [
        [[0, 0], [0, 1], [0, 2]],
        [[1, 0], [1, 1], [1, 2]],
        [[2, 0], [2, 1], [2, 2]],
        [[0, 0], [1, 0], [2, 0]],
        [[0, 1], [1, 1], [2, 1]],
        [[0, 2], [1, 2], [2, 2]],
        [[0, 0], [1, 1], [2, 2]],
        [[2, 0], [1, 1], [0, 2]]
    ]
    player_moves = self.moves.where(shape: shape)
    moves = player_moves.map { |move| [move.col_num, move.row_num] }
    (0..7).each do |i|
      winner_move = winner_moves[i]
      union_uniq = winner_move | moves
      if union_uniq.sort == moves.sort
        return winner_move
      end
    end
    false
  end

end
