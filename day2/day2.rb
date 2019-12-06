require_relative '../common/intcode_computer'

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
