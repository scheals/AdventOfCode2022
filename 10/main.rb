input = File.readlines(ARGV[0], chomp: true)

# The clock circuit ticks at a constant rate; each tick is called a cycle.
# X register - starts with the value 1
# noop - takes one cycle to complete. It has no other effect.
# addx V - takes two cycles to complete. After two cycles, the X register is increased by the value V. (V can be negative.)
# signal strength (the cycle number multiplied by the value of the X register)

# Sample results: 20 * 21 = 420, 60 * 19 = 1140, 100 * 18 = 1800, 140 * 21 = 2940, 180 * 16 = 2880, 220 * 18 = 3960, total 13140
# Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. What is the sum of these six signal strengths?

@x_register = 1
@cycles = [1]
def parse_input(input)
  input.each do |line|
    @cycles.push(@x_register)
    next if line == 'noop'

    @x_register += line.split(' ').last.to_i
    @cycles.push(@x_register)
  end
end

def signal_strengths(interval, amount)
  result = []
  amount.times do |i|
    cycle = 20 + interval * i
    result << @cycles[cycle - 1] * cycle
  end
  result
end

parse_input(input)
p1 = signal_strengths(40, 6).sum
puts p1 #14820

# It seems like the X register controls the horizontal position of a sprite.
# Specifically, the sprite is 3 pixels wide, and the X register sets the horizontal position of the middle of that sprite.
# You count the pixels on the CRT: 40 wide and 6 high. This CRT screen draws the top row of pixels left-to-right, then the row below that, and so on.
# The left-most pixel in each row is in position 0, and the right-most pixel in each row is in position 39.

display = []

@cycles.each_slice(40) do |row|
  row.each_with_index do |x_register, cycle|
    if ((x_register - 1)..(x_register + 1)).cover?(cycle)
      display.push('#')
    else
      display.push('.')
    end
  end
end
puts display.join # RZEKEHFA
