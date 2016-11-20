class Move
  include Mongoid::Document
  include Mongoid::Timestamps

  field :col_num, type: Integer
  field :row_num, type: Integer
  field :shape, type: String

  embedded_in :round
end
