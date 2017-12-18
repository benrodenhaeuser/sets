# The SetLike module defines the usual operations on sets (like intersection,
# union), set predicates (like subset, superset), as well as making available
# some other useful methods (including the ones provided by Enumerable).

# SetLike assumes that any class that includes it implements instance
# methods :retrieve/:[], :insert, :remove, :each/:each_pair and :size.

module SetLike
  include Enumerable

  def keys
    each.map(&:first)
  end

  def values
    each.map(&:last)
  end

  def include?(key)
    keys.include?(key)
  end

  def empty?
    size.zero?
  end

  def update(key, val)
    remove(key, self[key])
    insert(key, val)
  end
  alias []= update

  def delete(key)
    update(key, 0)
  end

  def to_s
    '{' + map { |key, val| "(#{key}: #{val})" }.join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: {" +
      map { |key, val| "#{key.inspect}: #{val}" }.join(', ') + '}>'
  end

  def flatten(flat = self.class.new)
    each.with_object(flat) do |(key, val), _|
      if key.instance_of?(self.class)
        key.flatten(flat)
      else
        flat.insert(key, val)
      end
    end
  end

  def hash
    each.map(&:hash).sum
  end

  def dup
    duplicate = self.class.new
    each { |key, val| duplicate[key.dup] = val }
    duplicate
  end

  # set operators

  def do_with(other)
    unless other.instance_of?(self.class)
      raise SetError, "#{self.class} instance needed"
    end

    return other.each unless block_given?
    other.each { |key, val| yield([key, val]) }
  end
  private :do_with

  def sum!(other)
    do_with(other) { |key, val| insert(key, val) }
    self
  end

  def sum(other)
    dup.sum!(other)
  end
  alias + sum

  def union!(other)
    do_with(other) do |key, _|
      self[key] = [self[key], other[key]].max
    end
    self
  end

  def union(other)
    dup.union!(other)
  end
  alias | union

  def difference!(other)
    do_with(other) do |key, _|
      self[key] = [0, self[key] - other[key]].max
    end
    self
  end

  def difference(other)
    dup.difference!(other)
  end
  alias - difference

  def intersection!(other)
    each do |key, _|
      self[key] = intersection(other)[key]
    end
  end

  def intersection(other)
    do_with(other).with_object(self.class.new) do |(key, _), the_intersection|
      the_intersection[key] = [self[key], other[key]].min
    end
  end
  alias & intersection

  # set predicates

  def compare_with?(other)
    return false unless other.instance_of?(self.class)

    (keys | other.keys).all? do |key|
      yield(self[key], other[key])
    end
  end
  private :compare_with?

  def subset?(other)
    compare_with?(other) do |s, o|
      s <= o
    end
  end
  alias <= subset?

  def proper_subset?(other)
    subset?(other) && self != other
  end
  alias < subset?

  def superset?(other)
    other.subset?(self)
  end
  alias >= superset?

  def proper_superset?(other)
    superset?(other) && self != other
  end
  alias > superset?

  def equivalent?(other)
    compare_with?(other) do |s, o|
      s == o
    end
  end
  alias == equivalent?
  alias eql? equivalent?
end
