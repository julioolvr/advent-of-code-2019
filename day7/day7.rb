require_relative '../common/intcode_computer'

program = File.read('./program.txt').split(',').map(&:to_i)

computer = IntcodeComputer.new

result = [0, 1, 2, 3, 4].permutation.map do |settings|
  settings.reduce(0) do |previous_output, setting|
    computer.reset
    computer.prepare_input([setting, previous_output])
    computer.execute(program).first
  end
end.max

puts result
