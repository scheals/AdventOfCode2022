strategy = File.readlines('./input.txt', "\n", chomp: true)
# # Y beats A paper vs rock
# # Z beats B scissors vs paper
# # X beats C rock vs scissors
# # win_points = 6
# # draw_points = 3
# # lose_points = 0
# # rock_points = 1
# # paper_points = 2
# # scissors_points = 3

class RPSMatch
  attr_reader :enemy_sign, :my_sign

  def initialize(enemy_sign, my_sign)
    translated_choices = choice_translator(enemy_sign, my_sign)
    @enemy_sign = translated_choices.first
    @my_sign = translated_choices.last
  end

  def choice_translator(enemy_sign, my_sign)
    choices = []
    case enemy_sign
    when 'A' then choices.push(Rock.new)
    when 'B' then choices.push(Paper.new)
    when 'C' then choices.push(Scissors.new)
    end

    case my_sign
    when 'X' then choices.push(Rock.new)
    when 'Y' then choices.push(Paper.new)
    when 'Z' then choices.push(Scissors.new)
    end
    choices
  end

  def play_match
    result = 0

    result += if enemy_sign.is_a?(my_sign.class)
                3
              elsif enemy_sign.wins?(my_sign)
                0
              else
                6
              end

    result += my_sign.points
    result
  end
end

class Rock
  def wins?(enemy_sign)
    if enemy_sign.is_a?(Rock)
      nil
    elsif enemy_sign.is_a?(Paper)
      false
    elsif enemy_sign.is_a?(Scissors)
      true
    end
  end

  def points
    1
  end
end


class Paper
  def wins?(enemy_sign)
    if enemy_sign.is_a?(Rock)
      true
    elsif enemy_sign.is_a?(Paper)
      nil
    elsif enemy_sign.is_a?(Scissors)
      false
    end
  end

  def points
    2
  end
end


class Scissors
  def wins?(enemy_sign)
    if enemy_sign.is_a?(Rock)
      false
    elsif enemy_sign.is_a?(Paper)
      true
    elsif enemy_sign.is_a?(Scissors)
      nil
    end
  end

  def points
    3
  end
end

matches = strategy.map do |match|
  sides = match.split
  RPSMatch.new(sides.first, sides.last).play_match
end

p matches
puts matches.sum # 13005
