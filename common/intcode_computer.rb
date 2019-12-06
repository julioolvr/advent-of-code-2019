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

    loop do
      opcode = program[@instruction_pointer] % 100
      first_mode = program[@instruction_pointer] / 100 % 10
      second_mode = program[@instruction_pointer] / 1_000 % 10
      third_mode = program[@instruction_pointer] / 10_000 % 10

      case opcode
      when OPCODE_ADD
        result = read_value(program[@instruction_pointer + 1], mode: first_mode) + read_value(program[@instruction_pointer + 2], mode: second_mode)
        write_value(program[@instruction_pointer + 3], result)
        @instruction_pointer += 4
      when OPCODE_MULTIPLY
        result = read_value(program[@instruction_pointer + 1], mode: first_mode) * read_value(program[@instruction_pointer + 2], mode: second_mode)
        write_value(program[@instruction_pointer + 3], result)
        @instruction_pointer += 4
      when OPCODE_READ_INPUT
        value = next_input
        write_value(program[@instruction_pointer + 1], value)
        @instruction_pointer += 2
      when OPCODE_OUTPUT
        output << read_value(program[@instruction_pointer + 1], mode: first_mode)
        @instruction_pointer += 2
      when OPCODE_STOP
        break
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

    def read_value(value, mode: 0)
      mode == 0 ? @memory[value] : value
    end

    def write_value(position, value)
      @memory[position] = value
    end
end
