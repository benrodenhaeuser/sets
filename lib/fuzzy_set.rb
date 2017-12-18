require_relative 'set_map'

class FuzzySet < SetMap
  @score_type = Numeric
  @min_score = 0
  @max_score = 1
end
