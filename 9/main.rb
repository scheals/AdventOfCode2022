class NodePlane
  attr_reader :nodes, :head, :tail, :rope

  DIRECTIONS = { 'U' => :up,
                 'D' => :down,
                 'L' => :left,
                 'R' => :right }.freeze
  def initialize(rope_length)
    starting_node = Node.new(Coordinate.new(0, 0))
    @nodes = [starting_node]
    @rope = create_rope(starting_node, rope_length)
    @head = rope.first
    @tail = rope.last
    rope.each { |knot| starting_node.contents.push(knot) }
  end

  def create_rope(starting_node, length)
    head = HeadKnot.new(starting_node)
    material = [head]
    rope = [head]
    (length - 1).times do
      knot = Knot.new(starting_node, material.pop)
      material.push(knot)
      rope.push(knot)
    end
    rope
  end

  def find(coordinate)
    nodes.find { |node| node.coordinate == coordinate }
  end

  def move(direction, amount)
    amount.times do
      head.move(navigate_to_node(head.current_node.coordinate.send(direction)))
      rope_catchup
    end
  end

  def rope_catchup
    rope[1..].each do |knot|
      unless knot.adjacent_to_parent? || knot.shares_node_with_parent?
        knot.catchup(navigate_to_node(knot.find_coordinate_for_catchup))
      end
    end
  end

  def navigate_to_node(coordinate)
    existing_node = find(coordinate)
    return existing_node if existing_node

    fresh_node = Node.new(coordinate)
    nodes << fresh_node
    fresh_node
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

  def eql?(other)
    self.==(other)
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

  def same_row?(coordinate)
    x == coordinate.x
  end

  def same_column?(coordinate)
    y == coordinate.y
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

class HeadKnot
  attr_accessor :current_node

  def initialize(current_node)
    @current_node = current_node
  end

  def move(node)
    current_node.contents.delete(self)
    @current_node = node
    current_node.contents.push(self)
  end
end

class Knot
  attr_reader :visited_nodes, :parent
  attr_accessor :current_node

  def initialize(current_node, parent)
    @current_node = current_node
    @visited_nodes = [current_node]
    @parent = parent
  end

  def visit_node(node)
    visited_nodes.push(node)
  end

  def catchup(node)
    new_destination = node
    current_node.contents.delete(self)
    @current_node = new_destination
    current_node.contents.push(self)
    @visited_nodes << new_destination
  end

  def shares_node_with_parent?
    current_node.contents.include?(parent)
  end

  def adjacent_to_parent?
    current_node.adjacent?(parent.current_node)
  end

  def find_coordinate_for_catchup
    parent_coordinate = parent.current_node.coordinate
    own_coordinate = current_node.coordinate
    return find_diagonal_coordinate unless own_coordinate.same_row?(parent_coordinate) || own_coordinate.same_column?(parent_coordinate)

    parent_adjacents = parent_coordinate.adjacents
    moves = %i[left right up down]
    possible_coordinates = moves.map { |direction| own_coordinate.send(direction) }
    possible_coordinates.find { |coordinate| parent_adjacents.include?(coordinate) }
  end

  def find_diagonal_coordinate
    own_coordinate = current_node.coordinate
    own_adjacents = own_coordinate.adjacents
    parent_coordinate = parent.current_node.coordinate
    parent_adjacents = parent_coordinate.adjacents
    (own_adjacents & parent_adjacents).find { |coordinate| coordinate.x != own_coordinate.x && coordinate.y != own_coordinate.y }
  end
end

input = File.readlines(ARGV[0], chomp: true)
space = NodePlane.new(2)
space.parse_input(input)
p1 = space.tail.visited_nodes.uniq.length
puts p1 # 6406

longer_rope_space = NodePlane.new(10)
longer_rope_space.parse_input(input)
p2 = longer_rope_space.tail.visited_nodes.uniq.length
puts p2 # 2643
