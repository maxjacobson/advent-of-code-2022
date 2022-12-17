require 'minitest/autorun'
require 'strscan'
require 'irb'

AOCFile = Struct.new(:name, :size, keyword_init: true)

class AOCDir
  def initialize
    @entries = {}
  end

  def recursive_directories
    Enumerator.new do |yielder|
      @entries.values.each do |entry|
        if entry.is_a?(AOCDir)
          yielder.yield entry

          entry.recursive_directories.each do |child_dir|
            yielder.yield child_dir
          end
        end
      end
    end
  end

  def at(cwd)
    if cwd.empty?
      self
    else
      @entries.fetch(cwd.first).at(cwd[1..])
    end
  end

  def record_dir(name)
    @entries[name] ||= AOCDir.new
  end

  def record_file(size, name)
    @entries[name] = AOCFile.new(name: name, size: size)
  end

  def size
    return @size if defined?(@size)

    @entries.values.reduce(0) do |acc, item|
      acc + item.size
    end
  end
end

class FileSystem
  COMMAND_PATTERN = /^\$ (.+)$\n/
  LS_OUTPUT_PATTERN = /^(dir|\d+) ([a-z\.]+)$\n/

  def initialize(filename)
    @text = File.read(filename)
  end

  def sum_of_small_directories
    root.
      recursive_directories.
      select { |dir| dir.size <= 100000 }.
      reduce(0) { |acc, dir| acc + dir.size }
  end

  def root
    return @root if defined?(@root)

    @root = AOCDir.new

    scanner = StringScanner.new(@text)

    cwd = []

    loop do
      scanner.scan(COMMAND_PATTERN)
      break if scanner.eos?
      command = scanner.captures[0]

      case command
      when "cd /"
        cwd = []
      when "cd .."
        cwd.pop
      when /cd (\w+)/
        cwd.push $1
      when "ls"
        while scanner.match?(LS_OUTPUT_PATTERN)
          output = scanner.scan(LS_OUTPUT_PATTERN)

          if scanner.captures[0] == 'dir'
            @root.at(cwd).record_dir(scanner.captures[1])
          else
            @root.at(cwd).record_file(scanner.captures[0].to_i, scanner.captures[1])
          end
        end
      else
        raise
      end
    end

    @root
  end
end

class FileSystemTest < Minitest::Test
  def test_example
    fs = FileSystem.new("./example.txt")

    assert_equal 95437, fs.sum_of_small_directories
  end

  def test_actual
    fs = FileSystem.new("./input.txt")

    assert_equal 1543140, fs.sum_of_small_directories
  end

  def test_example_part_two
    skip "not yet"
  end

  def test_actual_part_two
    skip "not yet"
  end
end
