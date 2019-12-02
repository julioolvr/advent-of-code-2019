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

program = ARGF.each_line.first.split(',').map(&:to_i)

computer = IntcodeComputer.new
result = computer.execute(program.clone)

puts "Part 1: #{result.first}"

EXPECTED_OUTPUT = 19_690_720

noun, verb = 100.times do |noun|
  verb = 100.times.find do |verb|
    computer.reset
    test_program = program.clone
    test_program[1] = noun
    test_program[2] = verb
    computer.execute(test_program).first == EXPECTED_OUTPUT
  end

  break noun, verb unless verb.nil?
end

puts "Part 2:"
puts "-  Noun: #{noun}"
puts "-  Verb: #{verb}"
puts "-  Result: #{noun * 100 + verb}"