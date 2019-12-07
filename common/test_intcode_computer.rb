require 'minitest/autorun'
require_relative './intcode_computer'

TEST_PROGRAMS = [
  {
    program: [1,0,0,0,99],
    expected_memory: [2,0,0,0,99],
  },
  {
    program: [2,3,0,3,99],
    expected_memory: [2,3,0,6,99],
  },
  {
    program: [2,4,4,5,99,0],
    expected_memory: [2,4,4,5,99,9801],
  },
  {
    program: [1,1,1,4,99,5,6,0,99],
    expected_memory: [30,1,1,4,2,5,6,0,99],
  },
  {
    program: [3,0,4,0,99],
    inputs: [42],
    expected_output: [42],
  },
  {
    program: [1002,4,3,4,33],
    expected_memory: [1002,4,3,4,99]
  },
  {
    program: [3,9,8,9,10,9,4,9,99,-1,8],
    inputs: [8],
    expected_output: [1]
  },
  {
    program: [3,9,8,9,10,9,4,9,99,-1,8],
    inputs: [7],
    expected_output: [0]
  },
  {
    program: [3,9,7,9,10,9,4,9,99,-1,8],
    inputs: [7],
    expected_output: [1]
  },
  {
    program: [3,9,7,9,10,9,4,9,99,-1,8],
    inputs: [9],
    expected_output: [0]
  },
  {
    program: [3,3,1108,-1,8,3,4,3,99],
    inputs: [8],
    expected_output: [1]
  },
  {
    program: [3,3,1108,-1,8,3,4,3,99],
    inputs: [7],
    expected_output: [0]
  },
  {
    program: [3,3,1107,-1,8,3,4,3,99],
    inputs: [7],
    expected_output: [1]
  },
  {
    program: [3,3,1107,-1,8,3,4,3,99],
    inputs: [9],
    expected_output: [0]
  },
  {
    program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9],
    inputs: [0],
    expected_output: [0]
  },
  {
    program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9],
    inputs: [7],
    expected_output: [1]
  },
]

class TestIntcodeComputer < Minitest::Test
  def setup
    @computer = IntcodeComputer.new
  end

  TEST_PROGRAMS.each_with_index do |definition, i|
    define_method("test_program_#{i}") do
      output, execution = @computer.execute(definition[:program])
      execution.resume

      definition.fetch(:inputs, []).each { |input| execution.resume(input) }

      if definition.key?(:expected_memory)
        assert_equal definition[:expected_memory], @computer.memory
      end

      if definition.key?(:expected_output)
        assert_equal definition[:expected_output], output
      end
    end
  end
end
