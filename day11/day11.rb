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

puts "Part 1: #{panels.keys.count}"

computer = IntcodeComputer.new
output, execution = computer.execute(program)
execution.resume

panels = Hash.new(BLACK)
robot_position = Vector.new(0, 0)
robot_direction = Vector.new(0, 1)
panels[robot_position] = WHITE

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

painted_positions = panels.keys
left = painted_positions.map { |position| position.x }.min
right = painted_positions.map { |position| position.x }.max
top = painted_positions.map { |position| position.y }.max
bottom = painted_positions.map { |position| position.y }.min

puts "Part 2:"
(bottom..top).to_a.reverse.each do |y|
  (left..right).each do |x|
    print panels[Vector.new(x, y)] == BLACK ? "\u25FE" : "\u25FD"
  end

  puts
end
