input = File.read('./input.txt').chomp.chars

p1 = input.each_index do |index|
  break index + 4 if input[index..(index + 3)].uniq.length == 4
end

puts p1 # 1142

p2 = input.each_index do |index|
  break index + 14 if input[index..(index + 13)].uniq.length == 14
end

puts p2 # 2803
