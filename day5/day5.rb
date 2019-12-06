require_relative '../common/intcode_computer'

program = ARGF.each_line.first.split(',').map(&:to_i)
computer = IntcodeComputer.new

computer.prepare_input([1])
output = computer.execute(program)
puts "Part 1: #{output.last}"

computer.reset
computer.prepare_input([5])
output = computer.execute(program)
puts "Part 2: #{output.first}"
