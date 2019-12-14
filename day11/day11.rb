require 'fiber'
require_relative '../common/intcode_computer'

Vector = Struct.new(:x, :y) do
  def +(other)
    Vector.new(x + other.x, y + other.y)
  end

  def rotate_left
    case [x, y]
    when [0, 1]
      Vector.new(-1, 0)
    when [-1, 0]
      Vector.new(0, -1)
    when [0, -1]
      Vector.new(1, 0)
    when [1, 0]
      Vector.new(0, 1)
    end
  end

  def rotate_right
    case [x, y]
    when [0, 1]
      Vector.new(1, 0)
    when [1, 0]
      Vector.new(0, -1)
    when [0, -1]
      Vector.new(-1, 0)
    when [-1, 0]
      Vector.new(0, 1)
    end
  end
end

BLACK = 0
WHITE = 1

TURN_LEFT = 0
TURN_RIGHT = 1

program = File.read('./program.txt').split(',').map(&:to_i)
computer = IntcodeComputer.new
output, execution = computer.execute(program)
execution.resume

panels = Hash.new(BLACK)
painted = 0
robot_position = Vector.new(0, 0)
robot_direction = Vector.new(0, 1)

while execution.alive?
  execution.resume(panels[robot_position])
  to_paint, turn = output.last(2)
  panels[robot_position] = to_paint
  robot_direction = case turn
                    when TURN_LEFT
                      robot_direction.rotate_left
                    when TURN_RIGHT
                      robot_direction.rotate_right
                    end
  painted += 1 unless panels.key?(robot_position)
  robot_position += robot_direction
end

puts panels.keys.count
