def fuel_for_mass(mass)
  mass / 3 - 2
end

def fuel_for_fuel(required_fuel)
  enumerator_from(required_fuel) { |fuel_mass| fuel_for_mass(fuel_mass) }
    .take_while { |fuel| fuel > 0 }
    .sum
end

# Builds an endless enumerator where each element is the result of calling the previous
# element with the given block. A starting value is required, and the first enumerated
# value is the result of calling the block with the given starting value.
# This is similar to Enumerator#produce from Ruby 2.7, but skipping the first value.
def enumerator_from(starting_value, &block)
  return Enumerator.produce((yield starting_value), &block) if Enumerator.respond_to?(:produce)

  Enumerator.new do |y|
    last = starting_value
    loop { y << (last = yield last) }
  end
end

fuel_per_module = ARGF.each_line.map { |n| fuel_for_mass(n.to_i) }
modules_fuel = fuel_per_module.sum
puts "Modules fuel (part 1): #{modules_fuel}"

fuel_for_fuel = fuel_per_module.sum { |fuel_for_module| fuel_for_fuel(fuel_for_module) }
puts "Total fuel (part 2): #{modules_fuel + fuel_for_fuel}"
