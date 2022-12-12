class Monkey
  attr_reader :item_worry_levels, :operation, :find_target
  attr_accessor :throw_counter, :relief_factor

  def initialize(item_worry_levels, operation_string, targetting_array)
    @item_worry_levels = item_worry_levels
    @operation = create_operation(operation_string)
    @find_target = create_targetting(targetting_array)
    @throw_counter = 0
    @relief_factor = nil
  end

  def create_operation(rule)
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1
      ->(old) {#{rule}}
    RUBY
  end

  def create_targetting(array)
    divisor = array.first
    true_branch = array[1]
    false_branch = array.last
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1
      lambda do |worry_level|
      if (worry_level % #{divisor}).zero?
        #{true_branch}
      else
        #{false_branch}
      end
      end
    RUBY
  end

  def play_round
    round = []
    queue = @item_worry_levels
    until queue.empty?
      worry_level = queue.shift
      new_worry_level = @operation.call(worry_level) / relief_factor
      target = @find_target.call(new_worry_level)
      @throw_counter += 1
      round << { item: new_worry_level, target: target }
    end
    round
  end
end

def parse_input(input)
  monkeys = []
  input.each do |monkey|
    items = parse_numbers(monkey[1])
    operation = parse_operation(monkey[2])
    divisor = parse_numbers(monkey[3]).first
    true_branch = parse_numbers(monkey[4]).first
    false_branch = parse_numbers(monkey[5]).first
    monkeys << Monkey.new(items, operation, [divisor, true_branch, false_branch])
  end
  monkeys
end

def parse_numbers(string)
  string.scan(/\d+/).map(&:to_i)
end

def parse_operation(string)
  string.split('= ').last
end

class MonkeyBusiness
  attr_reader :monkeys

  def initialize(monkeys)
    @monkeys = monkeys
  end

  def play_game(rounds, relief_factor)
    monkeys.each { |monkey| monkey.relief_factor = relief_factor }
    rounds.times do
      monkeys.each do |monkey|
        round_results = monkey.play_round
        execute_results(round_results)
      end
    end
  end

  def execute_results(results)
    results.each do |result|
      monkeys[result[:target]].item_worry_levels.push(result[:item])
    end
  end
end

input = File.readlines(ARGV[0], "\n\n", chomp: true).map { |monkey| monkey.split("\n") }
first_monkey_game = MonkeyBusiness.new(parse_input(input))
first_monkey_game.play_game(20, 3)
puts first_monkey_game.monkeys.max_by(2, &:throw_counter).map(&:throw_counter).reduce(:*) # p1 90294

second_monkey_game = MonkeyBusiness.new(parse_input(input))
second_monkey_game.play_game(10_000, 1)
puts second_monkey_game.monkeys.max_by(2, &:throw_counter).map(&:throw_counter).reduce(:*)
