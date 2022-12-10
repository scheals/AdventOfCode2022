input = File.readlines(ARGV[0], chomp: true)

# The clock circuit ticks at a constant rate; each tick is called a cycle.
# X register - starts with the value 1
# noop - takes one cycle to complete. It has no other effect.
# addx V - takes two cycles to complete. After two cycles, the X register is increased by the value V. (V can be negative.)
# signal strength (the cycle number multiplied by the value of the X register)

# Sample results: 20 * 21 = 420, 60 * 19 = 1140, 100 * 18 = 1800, 140 * 21 = 2940, 180 * 16 = 2880, 220 * 18 = 3960, total 13140
# Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. What is the sum of these six signal strengths?

@x_register = 1
@cycles = []
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
    result << @cycles[cycle - 2] * cycle
  end
  result
end

parse_input(input)
p1 = signal_strengths(40, 6).sum
puts p1

