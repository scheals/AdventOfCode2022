input = File.readlines('./input.txt', chomp: true)

# commands start with $
# need to track what directory I am in
# then throw whatever output into those directories
# have Directory objects similar to linked lists (keep knowledge of the parent)
# throw some Item class so I can keep info about its size

class Item
  attr_reader :size, :name

  def initialize(name, size)
    @name = name
    @size = size
  end
end

class Directory
  attr_reader :name, :parent
  attr_accessor :contents

  def initialize(name, contents: [], parent: nil)
    @name = name
    @contents = contents
    @parent = parent
  end

  def size
    result = []
    contents.each do |content|
      result << content.size
      result.flatten!
    end
    result.map(&:to_i).sum
  end
end

class FileSystem
  attr_reader :root
  attr_accessor :pwd

  def initialize
    @root = Directory.new('/')
  end

  def parse(input)
    @pwd = root

    input.each do |line|
      if a_command?(line) && line.include?('cd')
        @pwd = parse_cd(line)
      elsif !a_command?(line)
        @pwd.contents << parse_contents(line)
      end
    end
  end

  def a_command?(line)
    return true if line.include?('$')

    false
  end

  def parse_cd(line)
    return root if line.include?('/')
    return pwd.parent if line.include?('..')

    find_dir(line.split(' ').last).find { |dir| dir.parent == pwd } || create_dir(line)
  end

  def parse_contents(line)
    if line.include?('dir ')
      create_dir(line)
    else
      create_item(line)
    end
  end

  def dirs
    result = []
    queue = [root]
    until queue.empty?
      directory = queue.shift
      result << directory
      queue.push(directory.contents.select { |content| content.is_a?(Directory) })
      queue.flatten!
    end
    result
  end

  def find_dir(dir_name)
    dirs.select { |dir| dir.name == dir_name }
  end

  def create_dir(line)
    split_line = line.split(' ')
    Directory.new(split_line.last, parent: @pwd)
  end

  def create_item(line)
    split_line = line.split(' ')
    Item.new(split_line.last, split_line.first)
  end
end

p1_file_system = FileSystem.new
p1_file_system.parse(input)
p p1_file_system.dirs.filter_map { |dir| dir.size if dir.size <= 100_000 }.sum # p1 1432936

entire_space = 70_000_000
required_free_space = 30_000_000
used_space = entire_space - p1_file_system.root.size
space_to_free = required_free_space - used_space

p p1_file_system.dirs.select { |dir| dir.size >= space_to_free }.min_by(&:size).size # p2 272298
