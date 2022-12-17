require 'minitest/autorun'
require 'strscan'
require 'irb'
require 'securerandom'
require "set"

Tree = Struct.new(:height, :id, keyword_init: true)

class CounterFromOneDirection
  def initialize(trees)
    @trees = trees
  end

  def visible_trees
    result = []

    @trees.each do |row|
      row.each.with_index do |tree, pos|
        if pos.zero?
          # On perimeter -- def visible
          result.push(tree)
        elsif  row[0...pos].all? { |other| other.height < tree.height }
          # taller than all of the trees that came before me!
          # def visible
          result.push(tree)
        end
      end
    end

    result
  end
end

class Forest
  attr_reader :trees

  def initialize(filename)
    @trees = File.read(filename).lines.map do |line|
      line.chomp.split("").map { |height| Tree.new(height: height.to_i, id: SecureRandom.hex) }
    end
  end

  def visible_trees
    forest_from_all_four_angles.each_with_object(Set.new) do |trees_from_one_angle, set|
      CounterFromOneDirection.new(trees_from_one_angle).visible_trees.each do |tree|
        set.add(tree)
      end
    end.size
  end

  def highest_scenic_score
    scores = []

    @trees.each.with_index do |row, y|
      row.each.with_index do |tree, x|
        scores.push scenic_score_for(tree)
      end
    end

    scores.sort.last
  end

  private

  def forest_from_all_four_angles
    [
      @trees,
      @trees.transpose,
      @trees.map(&:reverse),
      @trees.transpose.map(&:reverse),
    ]
  end

  def scenic_score_for(tree_to_score)
    viewing_distances = []

    forest_from_all_four_angles.each do |trees_from_one_angle|
      viewing_distances.push viewing_distance_for(trees_from_one_angle, tree_to_score)
    end

    viewing_distances.reduce(:*)
  end

  def viewing_distance_for(trees_from_one_angle, tree_to_score)
    trees_from_one_angle.each do |row|
      row.each.with_index do |tree, idx|
        if tree.id == tree_to_score.id
          trees_in_this_direction = row[(idx + 1)..]
          count = 0
          trees_in_this_direction.each do |tree_in_this_direction|
            count += 1

            if tree_in_this_direction.height >= tree.height
              break
            end
          end


          return count
        end
      end
    end

    raise
  end
end

class ForestTest < Minitest::Test
  def test_example
    forest = Forest.new("./example.txt")
    assert_equal 21, forest.visible_trees
  end

  def test_actual
    forest = Forest.new("./input.txt")
    assert_equal 1812, forest.visible_trees
  end

  def test_example_part_two
    forest = Forest.new("./example.txt")
    assert_equal 8, forest.highest_scenic_score
  end

  def test_actual_part_two
    forest = Forest.new("./input.txt")
    assert_equal 315495, forest.highest_scenic_score
  end
end
