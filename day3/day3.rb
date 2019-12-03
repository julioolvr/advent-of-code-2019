require 'set'

Coordinates = Struct.new(:x, :y, :steps) do
  def manhattan_distance
    x.abs + y.abs
  end

  def ==(other)
    x == other.x && y == other.y
  end
  alias_method :eql?, :==

  def hash
    { x: x, y: y }.hash
  end
end

def wire_path_to_set(path)
  steps = 0
  current = Coordinates.new(0, 0)
  set = Set.new

  path.each do |step|
    direction, length = step.match(/(\w)(\d+)/).captures
    length = length.to_i

    case direction
    when 'U'
      (current.y + 1).upto(current.y + length) do |y|
        steps += 1
        current = Coordinates.new(current.x, y, steps)
        set << current unless set.include?(current)
      end
    when 'D'
      (current.y - 1).downto(current.y - length) do |y|
        steps += 1
        current = Coordinates.new(current.x, y, steps)
        set << current unless set.include?(current)
      end
    when 'L'
      (current.x - 1).downto(current.x - length) do |x|
        steps += 1
        current = Coordinates.new(x, current.y, steps)
        set << current unless set.include?(current)
      end
    when 'R'
      (current.x + 1).upto(current.x + length) do |x|
        steps += 1
        current = Coordinates.new(x, current.y, steps)
        set << current unless set.include?(current)
      end
    end
  end

  set
end

first_wire, second_wire = ARGF.each_line.map { |line| line.split(',') }
first_wire_set = wire_path_to_set(first_wire)
second_wire_set = wire_path_to_set(second_wire)
intersections_set = first_wire_set & second_wire_set

puts intersections_set.map(&:manhattan_distance).min
puts intersections_set.map do |intersection|
  first_wire_set.find { |step| step == intersection }.steps +
    second_wire_set.find { |step| step == intersection }.steps
end.min
