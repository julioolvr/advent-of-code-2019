require 'minitest/autorun'
require_relative './intcode_computer'

TEST_PROGRAMS = [
  [[1,0,0,0,99], [2,0,0,0,99]],
  [[2,3,0,3,99], [2,3,0,6,99]],
  [[2,4,4,5,99,0], [2,4,4,5,99,9801]],
  [[1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99]],
]

class TestIntcodeComputer < Minitest::Test
  def setup
    @computer = IntcodeComputer.new
  end

  TEST_PROGRAMS.each_with_index do |(input, output), i|
    define_method("test_program_#{i}") do
      assert_equal @computer.execute(input), output
    end
  end
end
