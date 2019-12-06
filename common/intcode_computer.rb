class IntcodeComputer
  OPCODE_ADD = 1
  OPCODE_MULTIPLY = 2
  OPCODE_STOP = 99

  def initialize
    reset
  end

  def execute(program)
    until program[@instruction_pointer] == OPCODE_STOP
      case program[@instruction_pointer]
      when OPCODE_ADD
        result = program[program[@instruction_pointer + 1]] + program[program[@instruction_pointer + 2]]
        program[program[@instruction_pointer + 3]] = result
        @instruction_pointer += 4
      when OPCODE_MULTIPLY
        result = program[program[@instruction_pointer + 1]] * program[program[@instruction_pointer + 2]]
        program[program[@instruction_pointer + 3]] = result
        @instruction_pointer += 4
      else
        raise "Invalid opcode #{program[@instruction_pointer]}"
      end
    end

    program
  end

  def reset
    @instruction_pointer = 0
  end
end
