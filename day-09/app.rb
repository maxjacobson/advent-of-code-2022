require 'minitest/autorun'
require 'irb'

Instruction = Struct.new(:direction, :amount, keyword_init: true)
Pos = Struct.new(:x, :y)

class Rope
  attr_reader :head, :tail

  def initialize(head:, tail:)
    @head = head
    @tail = tail
  end

  def move(direction:)
    new_head = new_pos_in_direction(head, direction)

    new_tail =
      if touching?(new_head, tail)
        tail
      elsif new_head.x == tail.x || new_head.y == tail.y
        new_pos_in_direction(tail, direction)
      else
        x_delta = new_head.x > tail.x ? 1 : -1
        y_delta = new_head.y > tail.y ? 1 : -1
        Pos.new(
          tail.x + x_delta,
          tail.y + y_delta,
        )
      end

    Rope.new(head: new_head, tail: new_tail)
  end

  private

  def touching?(p1, p2)
    (p1.x - p2.x).abs <= 1 && (p1.y - p2.y).abs <= 1
  end

  def new_pos_in_direction(pos, direction)
      case direction
      when "R"
        Pos.new(pos.x + 1, pos.y)
      when "L"
        Pos.new(pos.x - 1, pos.y)
      when "U"
        Pos.new(pos.x, pos.y + 1)
      when "D"
        Pos.new(pos.x, pos.y - 1)
      else
        raise
      end
  end
end

class RopePath
  def initialize(filename)
    @instructions = File.read(filename).lines.map do |line|
      direction, amount = line.chomp.split(" ")
      Instruction.new(direction: direction, amount: amount.to_i)
    end
  end

  def tail_positions_count
    complete_path.map(&:tail).uniq.count
  end

  private

  def complete_path
    return @complete_path if defined?(@complete_path)

    @complete_path = [
      Rope.new(
        head: Pos.new(0, 0),
        tail: Pos.new(0, 0),
      )
    ]

    @instructions.each do |instruction|
      instruction.amount.times do
        @complete_path.push @complete_path.last.move(direction: instruction.direction)
      end
    end


    @complete_path
  end
end

class RopeTest < Minitest::Test
  def test_example
    rope = RopePath.new("./example.txt")
    assert_equal 13, rope.tail_positions_count
  end

  def test_actual
    rope = RopePath.new("./input.txt")
    assert_equal 6498, rope.tail_positions_count
  end

  def test_example_part_two
    skip "not yet"
  end

  def test_actual_part_two
    skip "not yet"
  end
end
