require 'minitest/autorun'
require 'irb'

AddX = Struct.new(:amount, :started)
Noop = Class.new

class Computer
  def initialize(filename)
    @instructions = File.read(filename).lines.map do |line|
      case line
      when /addx ([\-\d]+)/
        AddX.new($1.to_i, false)
      when /noop/
        Noop.new
      else
        raise
      end
    end
  end

  def sum_of_signal_strengths
    values = []
    notable_cycle = 20

    x_over_time.each do |cycle, x|
      if cycle == notable_cycle
        values.push(x * cycle)
        notable_cycle += 40
      end
    end

    values.inject(:+)
  end

  private

  def x_over_time
    Enumerator.new do |yielder|
      (1..).inject(1) do |x, cycle|
        new_value =
          case @instructions.first
          when NilClass
            break x
          when Noop
            @instructions.shift
            x
          when AddX
            if @instructions.first.started
              instruction = @instructions.shift
              x + instruction.amount
            else
              @instructions.first.started = true
              x
            end
          else
            raise
          end

        yielder.yield(cycle, x)
        new_value
      end
    end
  end
end

class ComputerTest< Minitest::Test
  def test_example
    computer = Computer.new("./example.txt")
    assert_equal 13140, computer.sum_of_signal_strengths
  end

  def test_actual
    computer = Computer.new("./input.txt")
    assert_equal 16060, computer.sum_of_signal_strengths
  end

  def test_example_part_two
    skip "not yet"
  end

  def test_actual_part_two
    skip "not yet"
  end
end
