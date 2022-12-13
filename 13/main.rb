
class Packet
  attr_reader :array

  def initialize(list_string)
    @array = dangerous_parse(list_string)
  end

  def flat?
    return true if array == array.flatten

    false
  end

  def shorter?(packet)
    array.length < packet.array.length
  end

  def smaller?(packet)
    array.any? do |number|
      packet.each do |other_number|
        return true if number < other_number
      end
    end
  end

  def dangerous_parse(line)
    eval line
  end
end

def right_order?(first_packet, second_packet)
  first_packet.array.each_with_index do |element, i|
    other_element = second_packet.array[i]
    if element.is_a?(Numeric) && other_element.is_a?(Numeric)
      return false if element > second_packet.array[i]
    elsif element.is_a?(Array) && other_element.is_a?(Array)
      return compare?(element, other_element)
    elsif element.is_a?(Integer)
      element = [element]
      return compare?(element, other_element)
    elsif other_element.is_a?(Integer)
      other_element = [other_element]
      return compare?(element, other_element)
    end
  end
  true
end

def compare?(parent_element, other_parent_element)
  parent_element.each_with_index do |element, i|
    return false unless other_parent_element
    return false unless other_parent_element[i]

    other_element = other_parent_element.is_a?(Numeric) ? other_parent_element : other_parent_element[i]
    if element.is_a?(Numeric) && other_element.is_a?(Numeric)
      return false if element > other_parent_element[i]
    elsif element.is_a?(Array) && other_element.is_a?(Array)
      return compare?(element, other_element)
    elsif element.is_a?(Integer)
      element = [element]
      return compare?(element, other_element)
    elsif other_element.is_a?(Integer)
      other_element = [other_element]
      return compare?(element, other_element)
    end
  end
  true
end

input = (File.readlines(ARGV[0], chomp: true) - ['']).map { |line| Packet.new(line) }
results = []
input.each_slice(2) do |pair|
  first_packet = pair.first
  second_packet = pair.last
  results << { right_order: right_order?(first_packet, second_packet) }
end

p results.filter_map.with_index { |result, i| i + 1 if result[:right_order] }
