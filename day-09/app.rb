require 'minitest/autorun'
require 'irb'

Instruction = Struct.new(:direction, :amount, keyword_init: true)
Pos = Struct.new(:x, :y)

class PrintOut
  def initialize(rope)
    @rope = rope
  end

  def print
    positions = []

    r = @rope
    loop do
      break if r.nil?

      positions.push(r.position)
      r = r.next_knot
    end

    grid = Array.new(40).map {
      Array.new(40).map {
        '.'
      }
    }

    starting_pos = Pos.new(
      11,
      15,
    )

    positions.each.with_index do |pos, index|
      grid[starting_pos.y + pos.y][starting_pos.x + pos.x] = index.to_s
    end

    puts
    puts grid.reverse.map { |row| row.join("") }.join("\n")
    puts
  end
end

class Knot
  attr_reader :position, :next_knot

  def initialize(position:, next_knot:)
    @position = position
    @next_knot = next_knot

    @all_positions_ever = [position]
  end

  def print_out
    # PrintOut.new(self).print
  end

  def move_to(new_position)
    @position = new_position
    @all_positions_ever.push(new_position)

    if next_knot
      next_knot.follow_toward(new_position)
    end
  end

  def final_knot
    if next_knot
      next_knot.final_knot
    else
      self
    end
  end

  def unique_positions_count
    @all_positions_ever.uniq.count
  end

  protected

  def follow_toward(head_position)
    if touching?(head_position, position)
      # no-op
    elsif head_position.x == position.x
      move_to(
        Pos.new(
          head_position.x,
          head_position.y > position.y ? position.y + 1 : position.y - 1
        )
      )
    elsif head_position.y == position.y
      move_to(
        Pos.new(
          head_position.x > position.x ? position.x + 1 : position.x - 1,
          head_position.y
        )
      )
    else
      x_delta = head_position.x > position.x ? 1 : -1
      y_delta = head_position.y > position.y ? 1 : -1
      pos = Pos.new(
        position.x + x_delta,
        position.y + y_delta,
      )
      move_to(
        pos,
      )
    end
  end

  def touching?(p1, p2)
    (p1.x - p2.x).abs <= 1 && (p1.y - p2.y).abs <= 1
  end
end

class RopePath
  def initialize(filename, knots:)
    @instructions = File.read(filename).lines.map do |line|
      direction, amount = line.chomp.split(" ")
      Instruction.new(direction: direction, amount: amount.to_i)
    end
    @rope = knots.times.inject(nil) do |acc, _|
      Knot.new(position: Pos.new(0, 0), next_knot: acc)
    end
  end

  def tail_positions_count
    return @tail_positions_count if defined?(@tail_positions_count)

    @rope.print_out
    @instructions.each do |instruction|
      instruction.amount.times do
        pos = @rope.position

        new_pos =
          case instruction.direction
          when "R"
            Pos.new(@rope.position.x + 1, @rope.position.y)
          when "L"
            Pos.new(@rope.position.x - 1, @rope.position.y)
          when "U"
            Pos.new(@rope.position.x, @rope.position.y + 1)
          when "D"
            Pos.new(@rope.position.x, @rope.position.y - 1)
          else
            raise
          end

        @rope.move_to(new_pos)
        @rope.print_out
      end
    end

    @tail_positions_count = @rope.final_knot.unique_positions_count
  end
end

class RopeTest < Minitest::Test
  def test_example
    rope = RopePath.new("./example.txt", knots: 2)
    assert_equal 13, rope.tail_positions_count
  end

  def test_actual
    rope = RopePath.new("./input.txt", knots: 2)
    assert_equal 6498, rope.tail_positions_count
  end

  def test_example_part_two
    rope = RopePath.new("./larger-example.txt", knots: 10)
    assert_equal 36, rope.tail_positions_count
  end

  def test_actual_part_two
    rope = RopePath.new("./input.txt", knots: 10)
    assert_equal 2531, rope.tail_positions_count
  end
end
