class NodePlane
  attr_reader :nodes, :head, :tail

  DIRECTIONS = { 'U' => :up,
                 'D' => :down,
                 'L' => :left,
                 'R' => :right }.freeze

  REVERSE_DIRECTIONS = { up: :down,
                         down: :up,
                         left: :right,
                         right: :left }.freeze

  def initialize
    starting_node = Node.new(Coordinate.new(0, 0))
    @nodes = [starting_node]
    @head = Head.new(starting_node)
    @tail = Tail.new(starting_node)
    starting_node.contents.push(head, tail)
  end

  def find(coordinate)
    nodes.find { |node| node.coordinate == coordinate }
  end

  def move(direction, amount)
    amount.times do
      move_head(direction)
      unless tail.current_node.adjacent?(head.current_node) || tail.current_node.contents.include?(head)
        catchup
      end
    end
  end

  def navigate_to_node(direction)
    new_coordinate = head.current_node.coordinate.send(direction)
    existing_node = find(new_coordinate)
    return existing_node if existing_node

    fresh_node = Node.new(new_coordinate)
    nodes << fresh_node
    fresh_node
  end

  def move_head(direction)
    head.current_node.contents.delete(head)
    head.current_node = navigate_to_node(direction)
    head.last_move = direction
    head.current_node.contents.push(head)
  end

  def catchup
    new_destination = navigate_to_node(REVERSE_DIRECTIONS[head.last_move])
    tail.current_node.contents.delete(tail)
    tail.current_node.contents.push(tail)
    tail.current_node = new_destination
    tail.visited_nodes << new_destination
  end

  def parse_input(input)
    input.each do |instruction|
      prepared_instruction = instruction.split(' ')
      move(DIRECTIONS[prepared_instruction.first], prepared_instruction.last.to_i)
    end
  end
end

class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x.to_i
    @y = y.to_i
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def left
    Coordinate.new(x - 1, y)
  end

  def right
    Coordinate.new(x + 1, y)
  end

  def up
    Coordinate.new(x, y + 1)
  end

  def down
    Coordinate.new(x, y - 1)
  end

  def adjacents
    [up, up.left, up.right,
     down, down.left, down.right,
     right, left]
  end
end

class Node
  attr_reader :coordinate, :contents

  def initialize(coordinate, contents = [])
    @coordinate = coordinate
    @contents = contents
  end

  def adjacent?(node)
    return true if coordinate.adjacents.include?(node.coordinate)

    false
  end
end

class Head
  attr_accessor :last_move, :current_node

  def initialize(current_node)
    @current_node = current_node
    @last_move = nil
  end
end

class Tail
  attr_reader :visited_nodes
  attr_accessor :current_node

  def initialize(current_node)
    @current_node = current_node
    @visited_nodes = [current_node]
  end

  def visit_node(node)
    visited_nodes.push(node)
  end
end

input = File.readlines(ARGV[0], chomp: true)
space = NodePlane.new
space.parse_input(input)
p1 = space.tail.visited_nodes.uniq.length
puts p1 # 6406

