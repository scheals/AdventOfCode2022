pairs = File.readlines('./input.txt', chomp: true).map { |pair| pair.split(',') }
p pairs

def to_range(dashed_string)
  prepared_string = dashed_string.split('-')
  Range.new(prepared_string.first.to_i, prepared_string.last.to_i)
end

rangefied_pairs = pairs.map { |pair| pair.map { |stringified_range| to_range(stringified_range) } }

p rangefied_pairs

p rangefied_pairs.select { |pair| pair.first.cover?(pair.last) || pair.last.cover?(pair.first) }.length # 515

p rangefied_pairs.map { |pair| pair.map(&:to_a) }.reject { |pair| pair.first.intersection(pair.last).empty? }.length # 883
