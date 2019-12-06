class IntcodeComputer
  attr_accessor :memory

  OPCODE_ADD = 1
  OPCODE_MULTIPLY = 2
  OPCODE_READ_INPUT = 3
  OPCODE_OUTPUT = 4
  OPCODE_STOP = 99

  def initialize
    reset
  end

  def prepare_input(input)
    @input = input.each
  end

  def execute(program)
    @memory = program
    output = []

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
      when OPCODE_READ_INPUT
        value = next_input
        program[program[@instruction_pointer + 1]] = value
        @instruction_pointer += 2
      when OPCODE_OUTPUT
        output << program[program[@instruction_pointer + 1]]
        @instruction_pointer += 2
      else
        raise "Invalid opcode #{program[@instruction_pointer]}"
      end
    end

    output
  end

  def reset
    @instruction_pointer = 0
  end

  private

    def next_input
      @input.next
    end
end
