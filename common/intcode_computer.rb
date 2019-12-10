class IntcodeComputer
  attr_accessor :memory

  POSITION_MODE = 0
  IMMEDIATE_MODE = 1
  RELATIVE_MODE = 2

  OPCODE_ADD = 1
  OPCODE_MULTIPLY = 2
  OPCODE_READ_INPUT = 3
  OPCODE_OUTPUT = 4
  OPCODE_JUMP_IF_TRUE = 5
  OPCODE_JUMP_IF_FALSE = 6
  OPCODE_LESS_THAN = 7
  OPCODE_EQUALS = 8
  OPCODE_RELATIVE_BASE_OFFSET = 9
  OPCODE_STOP = 99

  def initialize
    reset
  end

  def execute(program)
    @memory = program.clone
    output = []

    execution = Fiber.new do
      loop do
        opcode = @memory.fetch(@instruction_pointer, 0) % 100
        first_mode = @memory.fetch(@instruction_pointer, 0) / 100 % 10
        second_mode = @memory.fetch(@instruction_pointer, 0) / 1_000 % 10
        third_mode = @memory.fetch(@instruction_pointer, 0) / 10_000 % 10

        case opcode
        when OPCODE_ADD
          result = read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode) + read_value(@memory.fetch(@instruction_pointer + 2, 0), mode: second_mode)
          write_value(@memory.fetch(@instruction_pointer + 3, 0), result, mode: third_mode)
          @instruction_pointer += 4
        when OPCODE_MULTIPLY
          result = read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode) * read_value(@memory.fetch(@instruction_pointer + 2, 0), mode: second_mode)
          write_value(@memory.fetch(@instruction_pointer + 3, 0), result, mode: third_mode)
          @instruction_pointer += 4
        when OPCODE_READ_INPUT
          value = Fiber.yield
          write_value(@memory.fetch(@instruction_pointer + 1, 0), value, mode: first_mode)
          @instruction_pointer += 2
        when OPCODE_OUTPUT
          output << read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode)
          @instruction_pointer += 2
        when OPCODE_JUMP_IF_TRUE
          predicate = read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode)
          if predicate != 0
            @instruction_pointer = read_value(@memory.fetch(@instruction_pointer + 2, 0), mode: second_mode)
          else
            @instruction_pointer += 3
          end
        when OPCODE_JUMP_IF_FALSE
          predicate = read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode)
          if predicate == 0
            @instruction_pointer = read_value(@memory.fetch(@instruction_pointer + 2, 0), mode: second_mode)
          else
            @instruction_pointer += 3
          end
        when OPCODE_LESS_THAN
          first_param = read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode)
          second_param = read_value(@memory.fetch(@instruction_pointer + 2, 0), mode: second_mode)

          if first_param < second_param
            write_value(@memory.fetch(@instruction_pointer + 3, 0), 1, mode: third_mode)
          else
            write_value(@memory.fetch(@instruction_pointer + 3, 0), 0, mode: third_mode)
          end

          @instruction_pointer += 4
        when OPCODE_EQUALS
          first_param = read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode)
          second_param = read_value(@memory.fetch(@instruction_pointer + 2, 0), mode: second_mode)

          if first_param == second_param
            write_value(@memory.fetch(@instruction_pointer + 3, 0), 1, mode: third_mode)
          else
            write_value(@memory.fetch(@instruction_pointer + 3, 0), 0, mode: third_mode)
          end

          @instruction_pointer += 4
        when OPCODE_RELATIVE_BASE_OFFSET
          first_param = read_value(@memory.fetch(@instruction_pointer + 1, 0), mode: first_mode)
          @relative_base += first_param
          @instruction_pointer += 2
        when OPCODE_STOP
          break
        else
          raise "Invalid opcode #{@memory[@instruction_pointer]}"
        end
      end
    end

    [output, execution]
  end

  def reset
    @instruction_pointer = 0
    @relative_base = 0
  end

  private

    def next_input
      @input.next
    rescue StopIteration
      nil
    end

    def read_value(value, mode: 0)
      case mode
      when POSITION_MODE
        @memory.fetch(value, 0)
      when IMMEDIATE_MODE
        value
      when RELATIVE_MODE
        @memory.fetch(@relative_base + value, 0)
      else
        raise "Invalid read mode #{mode}"
      end
    end

    def write_value(position, value, mode: 0)
      case mode
      when POSITION_MODE
        @memory[position] = value
      when RELATIVE_MODE
        @memory[@relative_base + position] = value
      else
        raise "Invalid write mode #{mode}"
      end
    end
end
