input = File.readlines('./input.txt', chomp: true).map(&:chars)

class Tree
  attr_reader :row, :column, :height

  def initialize(row, column, height)
    @row = row
    @column = column
    @height = height.to_i
  end

  def visible?(grove)
    return true if on_the_edge?(grove)
    return true if visible_in_row?(grove) || visible_in_column?(grove.transpose)

    false
  end

  def allows_visibility?(tree)
    height > tree.height
  end

  def on_the_edge?(grove)
    return true if row.zero? || column.zero? || row == grove.length - 1 || column == grove.transpose.length - 1

    false
  end

  def visible_in_row?(grove)
    return true if grove[row][(column + 1)..].all? { |tree| allows_visibility?(tree) } || grove[row][...column].all? { |tree| allows_visibility?(tree) }

    false
  end

  def visible_in_column?(grove)
    return true if grove[column][(row + 1)..].all? { |tree| allows_visibility?(tree) } || grove[column][...row].all? { |tree| allows_visibility?(tree) }

    false
  end

  def calculate_scenic_score(grove)
    return 0 if on_the_edge?(grove)

    [check_left_visibility(grove), check_right_visibility(grove), check_up_visibility(grove), check_down_visibility(grove)].reduce(&:*)
  end

  def check_left_visibility(grove)
    count = 1
    current_coordinate = Coordinate.new(row, column).left
    while current_coordinate.column.positive? && allows_visibility?(grove[row][current_coordinate.column])
      count += 1
      current_coordinate = current_coordinate.left
    end
    count
  end

  def check_right_visibility(grove)
    count = 1
    current_coordinate = Coordinate.new(row, column).right
    while current_coordinate.column < (grove.transpose.length - 1) && allows_visibility?(grove[row][current_coordinate.column])
      count += 1
      current_coordinate = current_coordinate.right
    end
    count
  end

  def check_up_visibility(grove)
    count = 1
    current_coordinate = Coordinate.new(row, column).up
    while current_coordinate.row.positive? && allows_visibility?(grove[current_coordinate.row][column])
      count += 1
      current_coordinate = current_coordinate.up
    end
    count
  end

  def check_down_visibility(grove)
    count = 1
    current_coordinate = Coordinate.new(row, column).down
    while current_coordinate.row < (grove.length - 1) && allows_visibility?(grove[current_coordinate.row][column])
      count += 1
      current_coordinate = current_coordinate.down
    end
    count
  end
end

class Coordinate
  attr_reader :row, :column
  
  def initialize(row, column)
    @row = row
    @column = column
  end

  def left
    self.class.new(row, column - 1)
  end

  def right
    self.class.new(row, column + 1)
  end

  def up
    self.class.new(row - 1, column)
  end

  def down
    self.class.new(row + 1, column)
  end
end

grove = input.each_with_index.map do |row, row_idx|
  row.each_with_index.map do |tree, col_idx|
    Tree.new(row_idx, col_idx, tree)
  end
end
visible_trees = []
grove.each { |row| row.each { |tree| visible_trees << tree if tree.visible?(grove) } }
puts visible_trees.size # 1679

scenic_scores = grove.map { |row| row.map { |tree| tree.calculate_scenic_score(grove) } }

p scenic_scores.flatten.max # 536625

# sample_input = File.readlines('./sample_input.txt', chomp: true).map(&:chars)
# sample_grove = sample_input.each_with_index.map do |row, row_idx|
#   row.each_with_index.map do |tree, col_idx|
#     Tree.new(row_idx, col_idx, tree)
#   end
# end
# sample_scenic_scores = sample_grove.map { |row| row.map { |tree| tree.calculate_scenic_score(sample_grove) } }
# p sample_scenic_scores
