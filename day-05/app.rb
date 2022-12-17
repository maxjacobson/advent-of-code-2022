require 'minitest/autorun'
require 'strscan'
require 'irb'

class Stack < Struct.new(:name, :value); end

class DrawingParser
  def initialize(drawing)
    @drawing = drawing
  end

  def stacks
    data = {}

    lines = @drawing.lines.reverse
    names = lines[0]
    lines[1..].each do |line|
      scanner = StringScanner.new(line)
      while scanner.skip_until(/\[/)
        data[scanner.pos] ||= []
        data[scanner.pos].push(scanner.getbyte)
      end
    end

    data.keys.map do |pos|
      Stack.new(names[pos].to_i, data[pos].reverse)
    end
  end
end

class DrawingParserTest < Minitest::Test
  def test_example
    parser = DrawingParser.new(<<~DRAWING)
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3
    DRAWING

    assert_equal [
      Stack.new(1, ['N', 'Z']),
      Stack.new(2, ['D', 'C', 'M']),
      Stack.new(3, ['P']),
    ], parser.stacks
  end
end

Instruction = Struct.new(:amount, :source, :target, keyword_init: true)

class InstructionsParser
  def initialize(text)
    @text = text
  end

  def instructions
    @text.lines.map do |line|
      match = line.match(/move (\d+) from (\d+) to (\d+)/)
      if match
        Instruction.new(amount: match[1].to_i, source: match[2].to_i, target: match[3].to_i)
      else
        raise "no match in #{line}"
      end
    end
  end
end

class InstructionsParserTest < MiniTest::Test
  def test_example
    parser = InstructionsParser.new(<<~TEXT)
      move 1 from 2 to 1
      move 3 from 1 to 3
    TEXT

    assert_equal [
      Instruction.new(amount: 1, source: 2, target: 1),
      Instruction.new(amount: 3, source: 1, target: 3),
    ], parser.instructions
  end
end

class Crane
  def initialize(filename)
    @input = File.read(filename)
    drawing, instructions = @input.split("\n\n")
    @stacks = DrawingParser.new(drawing).stacks
    @instructions = InstructionsParser.new(instructions).instructions
  end

  def apply_instructions
    @instructions.each do |instruction|
      source = @stacks.detect { |stack| stack.name == instruction.source }
      target = @stacks.detect { |stack| stack.name == instruction.target }
      instruction.amount.times do
        target.value.unshift source.value.shift
      end
    end
  end

  def top_values
    @stacks.map { |stack| stack.value.first }.compact.join("")
  end
end

class CraneTest < Minitest::Test
  def test_example
    crane = Crane.new('./example.txt')
    assert_equal 'NDP', crane.top_values
    crane.apply_instructions
    assert_equal 'CMZ', crane.top_values
  end

  def test_actual
    crane = Crane.new('./input.txt')
    crane.apply_instructions
    assert_equal '???', crane.top_values
  end
end
