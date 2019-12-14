require_relative '../common/intcode_computer'

program = File.read('./program.txt').split(',').map(&:to_i)
computer = IntcodeComputer.new
output, execution = computer.execute(program)
execution.resume

tiles = {}

output.each_slice(3) do |(x, y, tile)|
  tiles[[x, y]] = tile
end

puts tiles.values.count(2)
