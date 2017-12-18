require_relative 'set_map'

class MultiSet < SetMap
  @score_type = Integer
  @min_score = 0
  @max_score = Float::INFINITY
end
