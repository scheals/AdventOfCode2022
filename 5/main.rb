string_moves = File.readlines('./moves.txt', chomp: true)
ship_stacks = [
  %w[R N F V L J S M],
  %w[P N D Z F J W H],
  %w[W R C D G],
  %w[N B S],
  %w[M Z W P C B F N],
  %w[P R M W],
  %w[R T N G L S W],
  %w[Q T H F N B V],
  %w[L M H Z N F]
]

p ship_stacks

class Move
  attr_reader :amount, :start, :target

  def initialize(amount, start, target)
    @amount = amount.to_i
    @start = start.to_i
    @target = target.to_i
  end

  def self.parse(string)
    arguments = string.scan(/\d+/)
    Move.new(arguments.first, arguments[1], arguments.last)
  end
end

transformed_moves = string_moves.map { |move| Move.parse(move) }

transformed_moves.each do |move|
  (move.amount).times do
    target_stack = ship_stacks[move.target - 1]
    start_stack = ship_stacks[move.start - 1]
    target_stack.push(start_stack.pop)
  end
end

p1 = []
ship_stacks.each { |stack| p1.push(stack.last) }
puts p1.join # QPJPLMNNR
