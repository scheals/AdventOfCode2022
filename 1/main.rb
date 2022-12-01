input = File.readlines('./input.txt', '')
clean_input = input.map { |elf_inventory| elf_inventory.gsub("\n", ' ').strip }
inventory_arrays = clean_input.map { |elf_inventory| elf_inventory.split(' ') }
numberfied_inventories = inventory_arrays.map { |elf_inventory| elf_inventory.map(&:to_i) }
total_calories = numberfied_inventories.map(&:sum)
p total_calories.max(3).sum
