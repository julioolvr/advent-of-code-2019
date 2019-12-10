require_relative '../common/intcode_computer'

program = File.read('./program.txt').split(',').map(&:to_i)
computer = IntcodeComputer.new
output, execution = computer.execute(program)
execution.resume
execution.resume(1)
puts "Part 1: #{output.last}"

computer.reset
output, execution = computer.execute(program)
execution.resume
execution.resume(2)
puts "Part 2: #{output.last}"
