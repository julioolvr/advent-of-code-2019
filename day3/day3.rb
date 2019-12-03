require 'set'

Coordinates = Struct.new(:x, :y) do
  def manhattan_distance
    x.abs + y.abs
  end
end

def wire_path_to_set(path)
  current = Coordinates.new(0, 0)
  set = Set.new

  path.each do |step|
    direction, length = step.match(/(\w)(\d+)/).captures
    length = length.to_i

    case direction
    when 'U'
      (current.y + 1).upto(current.y + length) do |y|
        current = Coordinates.new(current.x, y)
        set << current
      end
    when 'D'
      (current.y - 1).downto(current.y - length) do |y|
        current = Coordinates.new(current.x, y)
        set << current
      end
    when 'L'
      (current.x - 1).downto(current.x - length) do |x|
        current = Coordinates.new(x, current.y)
        set << current
      end
    when 'R'
      (current.x + 1).upto(current.x + length) do |x|
        current = Coordinates.new(x, current.y)
        set << current
      end
    end
  end

  set
end

first_wire, second_wire = ARGF.each_line.map { |line| line.split(',') }
puts (wire_path_to_set(first_wire) & wire_path_to_set(second_wire)).map(&:manhattan_distance).min
