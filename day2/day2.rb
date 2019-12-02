program = ARGF.each_line.first.split(',').map(&:to_i)
program_counter = 0

OPCODE_ADD = 1
OPCODE_MULTIPLY = 2
OPCODE_STOP = 99

until program[program_counter] == OPCODE_STOP
  case program[program_counter]
  when OPCODE_ADD
    result = program[program[program_counter + 1]] + program[program[program_counter + 2]]
    program[program[program_counter + 3]] = result
    program_counter += 4
  when OPCODE_MULTIPLY
    result = program[program[program_counter + 1]] * program[program[program_counter + 2]]
    program[program[program_counter + 3]] = result
    program_counter += 4
  else
    raise "Invalid opcode #{program[program_counter]}"
  end
end

puts program[0]
