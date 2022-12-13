def dangerous_parse(line)
  eval line
end

# def right_order?(first_packet, second_packet)
#   first_packet.each_with_index do |element, i|
#     return false unless second_packet
#     return false unless second_packet[i]

#     other_element = second_packet[i]
#     if both_numbers?(element, other_element)
#       return false if element > second_packet[i]
#     elsif both_arrays?(element, other_element)
#       right_order?(element, other_element)
#     elsif element.is_a?(Numeric)
#       element = [element]
#       right_order?(element, other_element)
#     elsif other_element.is_a?(Numeric)
#       other_element = [other_element]
#       right_order?(element, other_element)
#     end
#   end
#   true
# end

def right_order?(first, second)
  return true if first.empty?

  first.each_with_index do |left, i|
    return false unless second[i] # If the right list runs out of items first, the inputs are not in the right order.

    right = second[i]
    if both_numbers?(left, right) # If both values are integers, the lower integer should come first.
      next if left == right # Otherwise, the inputs are the same integer; continue checking the next part of the input.

      return left < right # If the left integer is lower than the right integer, the inputs are in the right order.
      # If the left integer is higher than the right integer, the inputs are not in the right order.
    elsif both_arrays?(left, right) # If both values are lists,
      next if right_order?(left, right) # If the lists are the same length and no comparison makes a decision about the order, continue checking the next part of the input.

      return false
    elsif left.is_a?(Numeric) # If exactly one value is an integer,
      next if right_order?([left], right) # convert the integer to a list which contains that integer as its only value, then retry the comparison.

      return false
    elsif right.is_a?(Numeric) # If exactly one value is an integer,
      next if right_order?(left, [right]) # convert the integer to a list which contains that integer as its only value, then retry the comparison.

      return false
    end
  end
  true
end

def both_numbers?(a, b)
  a.is_a?(Numeric) && b.is_a?(Numeric)
end

def both_arrays?(a, b)
  a.is_a?(Array) && b.is_a?(Array)
end

input = (File.readlines(ARGV[0], chomp: true) - ['']).map { |line| dangerous_parse(line) }
results = []
input.each_slice(2) do |pair|
  first_packet = pair.first
  second_packet = pair.last
  results << right_order?(first_packet, second_packet)
end
p results
p results.filter_map.with_index { |result, i| i + 1 if result } #4831 was too small #6772 was too high
