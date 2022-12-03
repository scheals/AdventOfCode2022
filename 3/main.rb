# frozen_string_literal: true

rucksacks = File.readlines(*ARGV, chomp: true)
# split into compartments

compartmentalized_rucksacks = rucksacks.map do |rucksack|
  compartments = []
  compartments.push(rucksack[0...(rucksack.length / 2)])
  compartments.push(rucksack[(rucksack.length / 2)..])
  compartments
end

p compartmentalized_rucksacks

# find common items in compartments

common_items_in_rucksacks = compartmentalized_rucksacks.map do |rucksack|
  split_rucksack = rucksack.map(&:chars)
  split_rucksack.first.intersection(split_rucksack.last)
end

p common_items_in_rucksacks

# sum priorities of items present in both compartments

letters_array = ('a'..'z').to_a.union((('A'..'Z').to_a))
LETTER_VALUES = letters_array.zip((1..52).to_a).to_h

sums_of_priorities = common_items_in_rucksacks.map do |rucksack|
  rucksack.map(&LETTER_VALUES).sum
end

p sums_of_priorities.sum # 8243

# find the squads

elf_squads = []
rucksacks.each_slice(3) { |squad| elf_squads.push(squad) }

p elf_squads

# find the badges

badges = elf_squads.map do |squad|
  split_squad_rucksacks = squad.map(&:chars)
  split_squad_rucksacks.first.intersection(split_squad_rucksacks[1], split_squad_rucksacks.last)
end

p badges

# calculate the badges

p badges.flatten.map(&LETTER_VALUES).sum # 2631
