require_relative '../common/intcode_computer'

program = ARGF.each_line.first.split(',').map(&:to_i)
computer = IntcodeComputer.new
computer.prepare_input([1])
output = computer.execute(program)
puts output
