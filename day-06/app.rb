require 'minitest/autorun'
require 'strscan'
require 'irb'

class Comms
  def initialize(filename)
    @stream = File.read(filename).chomp
  end

  def start_of_packet_marker
    marker_after_this_many_unique_characters(4)
  end

  def start_of_message_marker
    marker_after_this_many_unique_characters(14)
  end

  private

  def marker_after_this_many_unique_characters(n)
    scanner = StringScanner.new(@stream)
    loop do
      marker = scanner.peek(n)
      if marker.chars.uniq.count == marker.length
        return scanner.pos + n
      else
        scanner.getbyte # advance by one
      end
    end
    raise
  end
end

class CommsTest < Minitest::Test
  def test_example
    comms = Comms.new("./example.txt")

    assert_equal 7, comms.start_of_packet_marker
  end

  def test_actual
    comms = Comms.new("./input.txt")

    assert_equal 1833, comms.start_of_packet_marker
  end

  def test_example_part_two
    comms = Comms.new("./example.txt")

    assert_equal 19, comms.start_of_message_marker
  end

  def test_actual_part_two
    comms = Comms.new("./input.txt")

    assert_equal 3425, comms.start_of_message_marker
  end
end
