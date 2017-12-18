# require 'simplecov'
# SimpleCov.root ".."
# SimpleCov.start

require 'minitest/autorun'

require_relative '../lib/set_like'
require_relative '../lib/set_map'
require_relative '../lib/multi_set'
require_relative '../lib/classical_set'
require_relative '../lib/fuzzy_set'

class SetMapTest < Minitest::Test
  def inserting_raises_exception
    set = SetMap.new
    assert_raises SetError do
      set.insert(1)
    end
  end
end

class ClassicalSetTest < Minitest::Test
  def test_elements_are_not_counted
    # skip
    arr = [1, 2, 3, 4, 4]
    set = ClassicalSet[*arr]
    actual_keys = set.keys
    expected_keys = arr.uniq
    assert_equal(expected_keys, actual_keys)
    actual_values = set.values.uniq
    expected_values = [1]
    assert_equal(expected_values, actual_values)
  end

  def test_inserting_element_already_present_does_not_affect_size
    # skip
    set = ClassicalSet[0, 1, 2]
    set.insert(1)
    actual = set.size
    expected = 3
    assert_equal(expected, actual)
  end

  def test_equality_is_order_independent
    # skip
    set1 = ClassicalSet[0, 1, 2]
    set2 = ClassicalSet[1, 2, 0]
    assert(set1.equivalent?(set2))
  end

  def test_equality_with_nested_sets
    # skip
    set1 = ClassicalSet[0, 1, 2]
    set2 = ClassicalSet[1, 2, 0]
    set3 = ClassicalSet[set1, 1, 2]
    set4 = ClassicalSet[1, set2, 2]
    assert(set1.equivalent?(set2))
    assert(set3.equivalent?(set4))
  end

  def test_equality_despite_repetitions
    # skip
    set1 = ClassicalSet[0, 1, 2, 2]
    set2 = ClassicalSet[0, 1, 2]
    assert(set1.equivalent?(set2))

    set3 = ClassicalSet[set1]
    set4 = ClassicalSet[set2]
    assert(set3.equivalent?(set4))
  end

  def test_equality_with_double_nesting_for_ordinary_sets
    # skip
    set1 = ClassicalSet[0, 1, 2]
    set2 = ClassicalSet[1, 2, 0]
    set3 = ClassicalSet[set1, 1, 2]
    set4 = ClassicalSet[set2, 1, 2]
    set5 = ClassicalSet[set3]
    set6 = ClassicalSet[set4]
    assert(set5.equivalent?(set6))
  end

  def test_proper_super_is_not_equal
    # skip
    set1 = ClassicalSet[0, 1, 2]
    set2 = ClassicalSet[0, 1, 2, 3]
    refute(set1.equivalent?(set2))
  end

  def test_insert_an_element
    # skip
    set1 = ClassicalSet[0, 1, 2]
    set1.insert(3)
    expected = ClassicalSet[0, 1, 3, 2]
    assert_equal(expected, set1)
  end

  def test_remove_an_element
    # skip
    set1 = ClassicalSet[0, 1, 2]
    set1.remove(2)
    actual = set1
    expected = ClassicalSet[0, 1]
    assert_equal(expected, actual)
  end

  def test_delete_an_element
    # skip
    set1 = ClassicalSet[0, 1, 2, 2]
    set1.delete(2)
    actual = set1
    expected = ClassicalSet[0, 1]
    assert_equal(expected, actual)
  end

  def test_intersection
    # skip
    set1 = ClassicalSet[1, 2, 3, 4, 5]
    set2 = ClassicalSet[3, 4, 5, 6, 7]
    actual = set1.intersection(set2)
    expected = ClassicalSet[3, 4, 5]
    assert_equal(expected, actual)
  end

  def test_intersection_2
    # skip
    set1 = ClassicalSet[1, 2, 3]
    set2 = ClassicalSet[1, 2, 3, 4, 5, 6]
    set1.intersection!(set2)
    actual = set1
    expected = ClassicalSet[1, 2, 3]
    assert_equal(expected, actual)
  end

  def test_difference
    # skip
    set1 = ClassicalSet[1, 2, 3]
    set2 = ClassicalSet[2, 3]
    expected = ClassicalSet[1]
    actual = set1.difference(set2)
    assert_equal(expected, actual)
  end

  def test_difference2
    # skip
    set1 = ClassicalSet[1, 2, 3]
    set2 = ClassicalSet[1, 4]
    expected = ClassicalSet[2, 3]
    assert_equal(expected, set1.difference(set2))
  end

  def test_union2    # skip
    set1 = ClassicalSet[1, 2, 3]
    set2 = ClassicalSet[4, 5, 6]
    expected = ClassicalSet[1, 2, 3, 4, 5, 6]
    assert_equal(expected, set1.union(set2))
  end

  def test_each_elem
    # skip
    set = ClassicalSet[0, 1, 2, 3]
    elems = []
    set.each_elem { |elem| elems << elem }
    expected = [0, 1, 2, 3]
    assert_equal(expected, elems)
  end

  def test_flatten_with_complicated_classical_set
    # skip
    set1 = ClassicalSet[1, 2, 3]
    set2 = ClassicalSet[set1, 4, 5]
    set3 = ClassicalSet[set2, 6, 7]
    set4 = ClassicalSet[set3, 1]
    set5 = ClassicalSet[set4, 4, set1]
    actual = set5.flatten
    expected = ClassicalSet[1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, actual)
  end

  def test_key_setter_validation
    set = ClassicalSet.new
    assert_raises SetError do
      set[3] = 4
    end
  end

  def test_key_setter_validation_2
    set = ClassicalSet.new
    assert_raises SetError do
      set[3] = -1
    end
  end

  def test_sum_is_union_for_classical_sets
    set1 = ClassicalSet[1, 2, 3]
    set2 = ClassicalSet[2, 3, 4]
    actual = set1.sum(set2)
    expected = set1.union(set2)
    assert_equal(expected, actual)
  end

  def test_from_enum
    set1 = ClassicalSet[1, 2, 3]
    expected = ClassicalSet[1, 2, 3]
    actual = set1
    assert_equal(expected, actual)
  end

  def test_size
    set = ClassicalSet[1, 2, 3]
    actual = set.size
    expected = set.values.sum
    assert_equal(expected, actual)
  end

  def test_error_with_different_set_types
    set1 = ClassicalSet[1, 2, 3]
    set2 = FuzzySet[1, 2, 3]
    assert_raises SetError do
      set1.union(set2)
    end
  end
end

class MultiSetTest < Minitest::Test
  def test_initializing_with_invalid_hash_raises_exception_fuzzy
    # skip
    assert_raises SetError do
      MultiSet.from_hash(1 => 0.5)
    end
  end

  def test_each_elem_2
    # skip
    set = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    actual = set.each_elem.to_a
    expected = [1, 2, 3, 3]
    assert_equal(expected, actual)
  end

  def test_size
    # skip
    multi_set = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    actual = multi_set.size
    expected = 4
    assert_equal(expected, actual)
  end

  def test_include
    # skip
    multi_set = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    assert_includes(multi_set, 2)
  end

  def test_include_2
    multi_set = MultiSet.new
    multi_set.update(1, 4)
    multi_set.update(1, 0)
    refute(multi_set.include?(1))
  end

  def test_delete_key
    # skip
    multi_set = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set.delete(3)
    actual = multi_set
    expected = MultiSet.from_hash(1 => 1, 2 => 1)
    assert_equal(expected, actual)
  end

  def test_remove
    # skip
    multi_set = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set.remove(3)
    actual = multi_set
    expected = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 1)
    assert_equal(expected, actual)
  end

  def test_sum!
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(2 => 1, 4 => 1)
    multi_set1.sum!(multi_set2)
    actual = multi_set1
    expected = MultiSet.from_hash(1 => 1, 2 => 2, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_union2
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(2 => 1, 4 => 1)
    multi_set1.union!(multi_set2)
    actual = multi_set1
    expected = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_difference3
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(3 => 3)
    actual = multi_set1.difference(multi_set2)
    expected = MultiSet.from_hash(1 => 1, 2 => 1)
    assert_equal(expected, actual)
  end

  def test_sum
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(2 => 1, 4 => 1)
    actual = multi_set1.sum(multi_set2)
    expected = MultiSet.from_hash(1 => 1, 2 => 2, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_sum_is_non_destructive # todo: fails
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(2 => 1, 4 => 1)
    multi_set1.sum(multi_set2)
    actual = multi_set1
    expected = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    assert_equal(expected, actual)
  end

  def test_union3
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(2 => 1, 4 => 1)
    actual = multi_set1.union(multi_set2)
    expected = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2, 4 => 1)
    assert_equal(expected, actual)
  end

  def test_union_is_non_destructive # todo: fails
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(2 => 1, 4 => 1)
    multi_set1.union(multi_set2)
    actual = multi_set1
    expected = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    assert_equal(expected, actual)
  end

  def test_intersection_3
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(3 => 3)
    actual = multi_set1.intersection(multi_set2)
    expected = MultiSet.from_hash(3 => 2)
    assert_equal(expected, actual)
  end

  def test_difference4
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(3 => 3)
    actual = multi_set1.difference(multi_set2)
    expected = MultiSet.from_hash(1 => 1, 2 => 1)
    assert_equal(expected, actual)
  end

  def test_difference_is_non_destructive
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(3 => 3)
    multi_set1.difference(multi_set2)
    actual = multi_set1
    expected = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    assert_equal(expected, actual)
  end

  def test_subset
    # skip
    multi_set1 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2)
    multi_set2 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2, 4 => 1, 5 => 1)
    multi_set3 = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 1)
    assert(multi_set1.subset?(multi_set2))
    refute(multi_set1.subset?(multi_set3))
  end

  def test_proper_sub
    # skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1.proper_subset?(multi_set2))
    refute(multi_set1.proper_subset?(multi_set3))
  end

  def test_super
    # skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set2.superset?(multi_set1))
    refute(multi_set3.superset?(multi_set1))
  end

  def test_proper_super
    # skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set2.proper_superset?(multi_set1))
    refute(multi_set3.proper_superset?(multi_set3))
  end

  def test_equivalence
    # skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1.equivalent?(multi_set2))
    refute(multi_set1.equivalent?(multi_set3))
  end

  def test_equality_with_nested_sets_for_MultiSets
    # skip
    set1 = MultiSet[0, 1, 2]
    set2 = MultiSet[1, 2, 0]
    set3 = MultiSet[set1, 1, 2]
    set4 = MultiSet[set2, 1, 2]
    assert(set1.equivalent?(set2))
    assert(set3.equivalent?(set4))
  end

  def test_equality_with_double_nesting
    # skip
    set1 = MultiSet[0, 1, 2]
    set2 = MultiSet[1, 2, 0]
    set3 = MultiSet[set1, 1, 2]
    set4 = MultiSet[set2, 1, 2]
    set5 = MultiSet[set3]
    set6 = MultiSet[set4]
    assert(set5.equivalent?(set6))
  end

  def test_each_elem_3
    # skip
    multi_set = MultiSet[1, 2, 3, 3]
    array = []
    multi_set.each_elem { |elem| array << elem }
    assert_equal(array, [1, 2, 3, 3])
  end

  def test_each_without_block
    # skip
    MultiSet.new.each.instance_of?(Enumerator)
  end

  def test_remove_decrements_elem_count
    # skip
    set = MultiSet[1, 2, 3, 3]
    set.remove(3)
    assert_equal(set.retrieve(3), 1)
  end

  def test_negative_elem_counts_do_not_occur
    # skip
    set = MultiSet[1, 2, 3]
    set.remove(1)
    set.remove(1)
    expected = 0
    assert_equal(0, set.retrieve(1))
  end

  def test_destructive_intersection
    # skip
    multi_set1 = MultiSet[1, 2, 3]
    multi_set2 = MultiSet[2, 3, 4]
    multi_set1.intersection!(multi_set2)
    expected = MultiSet[2, 3]
    assert_equal(expected, multi_set1)
  end

  def test_flatten
    # skip
    set1 = MultiSet[1, 2, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 7]
    actual = set3.flatten
    expected = MultiSet[1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, actual)
  end

  def test_flatten_with_elements_appearing_multiple_times
    # skip
    set1 = MultiSet[1, 2, 3, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 6, 7]
    actual = set3.flatten
    expected = MultiSet[1, 2, 3, 3, 4, 5, 6, 6, 7]
    assert_equal(expected, actual)
  end

  def test_flatten_with_complicated_set
    # skip
    set1 = MultiSet[1, 2, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 7]
    set4 = MultiSet[set3, 1]
    set5 = MultiSet[set4, 4, set1]

    actual = set5.flatten
    expected = MultiSet[1, 2, 3, 4, 5, 6, 7, 1, 4, 1, 2, 3]
    assert_equal(expected, actual)
  end

  def test_to_s
    # skip
    set1 = MultiSet[1, 2, 3, 3]
    set2 = MultiSet[set1, 4, 5, 5]
    set3 = MultiSet[set2, 6, 6, 7]
    set4 = MultiSet[set3, 1]
    set5 = MultiSet[set4, 4, set1]
    actual = set5.to_s
    expected = '{({({({({(1: 1), (2: 1), (3: 2)}: 1), (4: 1), (5: 2)}: 1), (6: 2), (7: 1)}: 1), (1: 1)}: 1), (4: 1), ({(1: 1), (2: 1), (3: 2)}: 1)}'
    assert_equal(expected, set5.to_s)
  end

  def test_key_setter_validation
    set = MultiSet.new
    assert_raises SetError do
      set[3] = 0.5
    end
  end

  def test_key_setter_validation_2
    set = MultiSet.new
    assert_raises SetError do
      set[3] = -10
    end
  end

  def test_insert_raises_exception_with_fraction
    set = MultiSet.new
    assert_raises SetError do
      set.insert(1, 0.5)
    end
  end

  def test_inspect_for_multiset
    set = MultiSet.from_hash(1 => 2)
    actual = set.inspect
    expected = "#<MultiSet: {1: 2}>"
    assert_equal(expected, actual)
  end

  def test_from_hash
    actual = MultiSet.from_hash(1 => 2)
    expected = MultiSet.from_hash(1 => 2)
    assert_equal(expected, actual)
  end

  def test_size_2
    set = MultiSet.from_hash(1 => 1, 2 => 1, 3 => 2, 4 => 1, 5 => 1)
    actual = set.size
    expected = set.values.sum
    assert_equal(expected, actual)
  end
end

class FuzzySetTest < Minitest::Test
  def test_initializing_with_invalid_hash_raises_exception_fuzzy
    # skip
    assert_raises SetError do
      set = FuzzySet.from_hash(1 => 10)
    end
  end

  def test_initialization
    # skip
    set1 = FuzzySet.from_hash(3 => 0.5)
    assert_instance_of(FuzzySet, set1)
  end

  def test_insert
    # skip
    set = FuzzySet.new
    set.insert(3, 0.5)
    actual = set
    expected = FuzzySet.from_hash(3 => 0.5)
    assert_equal(expected, actual)
  end

  def update_with_invalid_value_raises_exception
    set = FuzzySet.new
    assert_raises SetError do
      set.update(4, 10)
    end
  end

  def test_invalid_fuzzy_member_inserted
    # skip
    set = FuzzySet.new
    assert_raises SetError do
      set.insert(4, 10)
    end
  end

  def test_insert_with_invalid_value_2
    set = FuzzySet.new
    assert_raises SetError do
      set.insert(4, -1)
    end
  end

  def test_remove
    # skip
    set = FuzzySet.new
    set.insert(4, 0.2)
    set.remove(4, 0.1)
    actual = set
    expected = FuzzySet.from_hash(4 => 0.1)
    assert_equal(expected, actual)
  end

  def test_sum
    # skip
    set1 = FuzzySet.from_hash(1 => 0.3, 2 => 0.4)
    set2 = FuzzySet.from_hash(2 => 0.3, 3 => 0.6)
    actual = set1.sum(set2)
    expected = FuzzySet.from_hash(1 => 0.3, 2 => 0.7, 3 => 0.6)
    assert_equal(expected, actual)
  end

  def test_sum_is_non_destructive
    # skip
    set1 = FuzzySet.from_hash(1 => 0.3, 2 => 0.4)
    set2 = FuzzySet.from_hash(2 => 0.3, 3 => 0.6)
    set1.sum(set2)
    actual = set1
    expected = FuzzySet.from_hash(1 => 0.3, 2 => 0.4)
    assert_equal(expected, actual)
  end

  def test_sum!
    # skip
    set1 = FuzzySet.from_hash(1 => 0.3, 2 => 0.4)
    set2 = FuzzySet.from_hash(2 => 0.3, 3 => 0.6)
    set1.sum!(set2)
    actual = set1
    expected = FuzzySet.from_hash(1 => 0.3, 2 => 0.7, 3 => 0.6)
    assert_equal(expected, actual)
  end

  def test_key_setter_validation
    set = FuzzySet.new
    assert_raises SetError do
      set[3] = 4
    end
  end

  def test_inspect_for_fuzzy_set
    set = FuzzySet.from_hash(1 => 0.5)
    actual = set.inspect
    expected = "#<FuzzySet: {1: 0.5}>"
    assert_equal(expected, actual)
  end

  def test_size_3
    set = FuzzySet.from_hash(1 => 0.3, 2 => 0.4)
    actual = set.size
    expected = set.values.sum
    assert_equal(expected, actual)
  end

  def test_size_with_deletions
    set = FuzzySet.from_hash(1 => 0.3, 2 => 0.4)
    set.remove(1, 0.2)
    set.insert(5, 0.4)
    set.remove(5, 0.2)
    actual = set.size
    expected = set.values.sum
    assert_equal(expected, actual)
  end

  def test_empty_predicate_and_size
    set = FuzzySet.from_hash(1 => 0.3, 2 => 0.4)
    assert_equal(0.7, set.size)
    set.remove(1, 0.3)
    assert_equal(0.4, set.size)
    set.remove(2, 0.4)
    assert(set.empty?)
  end
end
