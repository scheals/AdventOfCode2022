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
end

grove = input.each_with_index.map do |row, row_idx|
  row.each_with_index.map do |tree, col_idx|
    Tree.new(row_idx, col_idx, tree)
  end
end
visible_trees = []
grove.each { |row| row.each { |tree| visible_trees << tree if tree.visible?(grove) } }
puts visible_trees.size # 1679
