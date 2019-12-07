require 'fiber'
require_relative '../common/intcode_computer'

program = File.read('./program.txt').split(',').map(&:to_i)

computer = IntcodeComputer.new

result = [0, 1, 2, 3, 4].permutation.map do |settings|
  settings.reduce(0) do |previous_output, setting|
    computer.reset
    output, execution = computer.execute(program)
    execution.resume
    execution.resume(setting)
    execution.resume(previous_output)
    output.first
  end
end.max

puts "Part 1: #{result}"

def build_amplifier(program, setting)
  computer = IntcodeComputer.new
  output, execution = computer.execute(program)
  execution.resume
  execution.resume(setting)
  { output: output, execution: execution }
end

result = [5, 6, 7, 8, 9].permutation.map do |settings|
  amplifiers = settings.map { |setting| build_amplifier(program, setting) }

  amplifiers
    .cycle.lazy.take_while { amplifiers.last[:execution].alive? }
    .reduce(0) do |previous_output, amplifier|
      amplifier[:execution].resume(previous_output)
      amplifier[:output].last
    end
end.max

puts "Part 2: #{result}"
