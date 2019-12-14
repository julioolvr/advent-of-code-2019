require_relative '../common/intcode_computer'

program = File.read('./program.txt').split(',').map(&:to_i)
computer = IntcodeComputer.new
output, execution = computer.execute(program)
execution.resume

tiles = {}

output.each_slice(3) do |(x, y, tile)|
  tiles[[x, y]] = tile
end

puts "Part 1: #{tiles.values.count(2)}"

# Got these sizes from reviewing `tiles` in Part 1 above
WIDTH = 41
HEIGHT = 23
SIZE_FACTOR = 16

BACKGROUND = 0
WALL = 1
BLOCK = 2
PADDLE = 3
BALL = 4

TILES_COLORS = {
  BACKGROUND => 'black',
  WALL => 'brown',
  BLOCK => 'aqua',
  PADDLE => 'maroon',
  BALL => 'olive'
}

DIRECTION_LEFT = -1
DIRECTION_RIGHT = 1
DIRECTION_NONE = 0

require 'ruby2d'

set width: (WIDTH + 1) * SIZE_FACTOR, height: (HEIGHT + 1) * SIZE_FACTOR

Thread.new do
  computer = IntcodeComputer.new

  # Modify memory to play
  program[0] = 2

  output, execution = computer.execute(program)
  execution.resume

  squares = {}

  current_paddle_x = 0
  current_ball_x = 0

  # Do a first pass to create a Square instance for each tile
  output.each_slice(3) do |(x, y, tile)|
    if x == -1 && y == 0
      puts "Score: #{tile}"
    else
      squares[[x, y]] = Square.new(
        x: x * SIZE_FACTOR,
        y: y * SIZE_FACTOR,
        size: SIZE_FACTOR,
        color: TILES_COLORS[tile]
      )
    end
  end

  loop do
    output.each_slice(3) do |(x, y, tile)|
      if x == -1 && y == 0
        puts "Score: #{tile}"
      else
        case tile
        when PADDLE
          current_paddle_x = x
        when BALL
          current_ball_x = x
        end

        squares[[x, y]].color = TILES_COLORS[tile]
      end
    end

    output.clear

    direction = if current_paddle_x < current_ball_x
                  DIRECTION_RIGHT
                elsif current_paddle_x > current_ball_x
                  DIRECTION_LEFT
                else
                  DIRECTION_NONE
                end

    execution.resume(direction)
  end
end

show
