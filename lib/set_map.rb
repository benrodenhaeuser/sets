require_relative 'set_like'
class SetError < RuntimeError; end

# The SetMap class implements the methods that directly access the hash table
# we internally use to represent sets.

class SetMap
  include SetLike

  class << self
    def score_type
      @score_type || raise(SetError, '@score_type not initialized')
    end

    def min_score
      @min_score || raise(SetError, '@min_score not initialized')
    end

    def max_score
      @max_score || raise(SetError, '@max_score not initialized')
    end

    def valid_score?(val)
      (min_score..max_score).cover?(val) && val.is_a?(score_type)
    end

    def [](*list)
      set = new
      list.each { |key| set.insert(key) }
      set
    end

    def from_hash(hsh)
      unless hsh.instance_of?(Hash)
        raise(SetError, 'Hash instance needed')
      end
      set = new
      hsh.each_pair { |key, val| set.insert(key, val) }
      set
    end
  end

  def initialize
    @hash = {}
    @size = 0
  end

  def size
    @size
  end

  def retrieve(key)
    @hash[key] ? @hash[key] : 0
  end
  alias [] retrieve

  def insert(key, val = 1)
    raise(SetError, 'Invalid value') unless self.class.valid_score?(val)
    old_score = self[key]
    @hash[key] = [self[key] + val, self.class.max_score].min
    @size = (@size + (self[key] - old_score)).round(1)
  end

  def remove(key, val = 1)
    raise(SetError, 'Invalid value') unless self.class.valid_score?(val)
    old_score = self[key]
    @hash[key] = [self[key] - val, self.class.min_score].max
    @size = (@size - (old_score - self[key])).round(2)
  end

  def each_pair
    return to_enum(:each_pair) unless block_given?

    @hash.each_pair do |key, val|
      yield([key, val]) if val != 0
    end

    self
  end
  alias each each_pair

  def each_elem
    return to_enum(:each_elem) unless block_given?
    each_pair { |key, val| val.ceil.times { yield(key) } }
    self
  end
end
