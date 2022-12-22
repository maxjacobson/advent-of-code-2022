require 'minitest/autorun'
require 'irb'

class Monkey
  attr_reader(
    :name,
    :operation,
    :test,
    :when_true,
    :when_false,
  )

  attr_accessor(
    :inspection_counter,
    :items,
  )

  def self.parse(text)
    name, starting_items, operation, test, when_true, when_false = text.lines
    Monkey.new(
      name: name.match(/Monkey (\d+)/)[1].to_i,
      items: starting_items.match(/Starting items: (.+)/)[1].split(",").map(&:to_i),
      operation: parse_operation(operation),
      test: parse_test(test),
      when_true: parse_when_true(when_true),
      when_false: parse_when_false(when_false),
    )
  end

  def self.parse_operation(str)
    formula = str.match(/Operation: new = (.+) ([\*\+]) (.+)$/)
    operand_one = formula[1]
    operator = formula[2]
    operand_two = formula[3]

    ->(old) {
      a = operand_one == 'old' ? old : operand_one.to_i
      b = operand_two == 'old' ? old : operand_two.to_i

      a.public_send(operator, b)
    }
  end

  def self.parse_test(str)
    test = str.match(/Test: divisible by (\d+)$/)

    ->(worry_level) {
      worry_level % test[1].to_i == 0
    }
  end

  def self.parse_when_true(str)
    str.match(/If true: throw to monkey (\d+)$/)[1].to_i
  end

  def self.parse_when_false(str)
    str.match(/If false: throw to monkey (\d+)$/)[1].to_i
  end

  def initialize(name:, items:, operation:, test:, when_true:, when_false:)
    @name = name
    @items = items
    @operation = operation
    @when_true = when_true
    @when_false = when_false
    @test = test
    @inspection_counter = 0
  end
end

class MonkeyTest < Minitest::Test
  def test_parse
    monkey = Monkey.parse(<<~TEXT.chomp)
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3
    TEXT

    assert_equal monkey.name, 0
    assert_equal monkey.items, [79, 98]
    assert_equal monkey.operation.(2), 2 * 19
    assert_equal monkey.test.(23 * 2), true
    assert_equal monkey.test.(24 * 2), false
    assert_equal monkey.when_true, 2
    assert_equal monkey.when_false, 3
  end
end

class MonkeyBusiness
  def initialize(filename)
    @filename = filename
  end

  def product_of_two_most_active_monkeys_after_twenty_rounds
    monkeys = File.read(@filename).split("\n\n").map do |monkey_text|
      Monkey.parse(monkey_text)
    end

    20.times do
      monkeys.each do |monkey|
        monkey.items.each.with_index do |item, index|
          monkey.inspection_counter += 1
          monkey.items[index] = item = monkey.operation.(item)
          monkey.items[index] = item = (item / 3.0).floor
          if monkey.test.(item)
            monkeys[monkey.when_true].items.push(item)
          else
            monkeys[monkey.when_false].items.push(item)
          end
        end

        monkey.items = []
      end
    end

    monkeys.map(&:inspection_counter).sort.reverse.take(2).inject(:*)
  end
end

class MonkeyBusinessTest < Minitest::Test
  def test_example
    business = MonkeyBusiness.new("./example.txt")
    assert_equal 10605, business.product_of_two_most_active_monkeys_after_twenty_rounds
  end

  def test_actual
    business = MonkeyBusiness.new("./input.txt")
    assert_equal 66124, business.product_of_two_most_active_monkeys_after_twenty_rounds
  end

  def test_example_part_two
    skip "not yet"
  end

  def test_actual_part_two
    skip "not yet"
  end
end
