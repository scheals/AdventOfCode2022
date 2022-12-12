class Node
  attr_reader :height, :row, :column
  attr_accessor :parent

  HEIGHTS = ('a'..'z').map.with_index { |letter, i| [letter, i] }.to_h.merge({ 'S' => 0, 'E' => 26 })

  def initialize(letter, row, column)
    @height = HEIGHTS[letter]
    @starting_position = letter == 'S'
    @target_position = letter == 'E'
    @row = row
    @column = column
    @parent = nil
  end

  def start?
    @starting_position
  end

  def target?
    @target_position
  end

  def traversible?(node)
    height + 1 >= node.height
  end

  def to_s
    return 'S' if @starting_position
    return 'E' if @target_position

    @height.to_s
  end
end

class Traveller
  attr_reader :heightmap, :start, :target

  MOVES = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ].freeze

  def initialize(heightmap)
    @heightmap = heightmap
    @start = heightmap.flatten.find(&:start?)
    @start.parent = "I'm the start dummy"
    @target = heightmap.flatten.find(&:target?)
  end

  def traverse
    queue = [start]
    result = []
    until queue.empty?
      current_position = queue.shift
      result << current_position
      break if current_position == @target

      find_potential_moves(current_position).each { |move| queue << move }
    end
    result
  end

  def find_potential_moves(position)
    moves = []
    MOVES.each do |move|
      new_row = position.row + move.first
      next if new_row.negative? || new_row > heightmap.length - 1

      new_column = position.column + move.last
      next if new_column.negative? || new_column > heightmap.first.length - 1

      new_position = heightmap[new_row][new_column]
      next unless position.traversible?(new_position)
      next if new_position.parent

      new_position.parent = position
      moves << new_position
    end
    moves
  end
end

def find_path(journey)
  path = []
  node = journey.last
  until node.parent == "I'm the start dummy"
    path << node
    node = node.parent
  end
  path
end

input = File.readlines(ARGV[0], chomp: true).map(&:chars).map.with_index { |row, row_i| row.map.with_index { |letter, column_i| Node.new(letter, row_i, column_i) } }
traveller = Traveller.new(input)
p find_path(traveller.traverse).length # p1 423
