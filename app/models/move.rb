class Move
  include Mongoid::Document
  include Mongoid::Timestamps

  field :col_num, type: String
  field :row_num, type: String
end
