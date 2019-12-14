asteroids_map = ARGF.each_line.map(&:chomp).map do |line|
  line.split('').map do |value|
    value == '#'
  end
end

Vector = Struct.new(:x, :y) do
  def length
    @length ||= Math.sqrt(x ** 2 + y ** 2)
  end

  def dot(other)
    x * other.x + y * other.y
  end

  def angle(other)
    Math.acos(dot(other) / (length * other.length))
  end

  def -(other)
    Vector.new(x - other.x, y - other.y)
  end
end

VERTICAL = Vector.new(0, -1)

def visible_asteroids_from(from, asteroids_map)
  distances_to_others(from, asteroids_map)
    .map { |distance| angle_to_vertical(distance) }
    .uniq
end

def distances_to_others(from, asteroids_map)
  height = asteroids_map.size
  width = asteroids_map.first.size

  all_asteroids(asteroids_map)
    .map { |other| other - from }
    .sort_by(&:length)
    .drop(1)
end

def all_asteroids(asteroids_map)
  height = asteroids_map.size
  width = asteroids_map.first.size

  (0...width).to_a.product((0...height).to_a)
    .select { |(x, y)| asteroids_map[y][x] }
    .map { |(x, y)| Vector.new(x, y) }
end

def angle_to_vertical(vector)
  angle = vector.angle(VERTICAL).round(10)
  angle = 2 * Math::PI - angle if vector.x.negative?
  angle
end

best_coordinates = all_asteroids(asteroids_map).max_by { |coordinates| visible_asteroids_from(coordinates, asteroids_map).count }

result = visible_asteroids_from(best_coordinates, asteroids_map).count

puts "Part 1: #{result}"

# Create an array of arrays, where each internal array has a list of tuples
# of [distance_vector, angle_to_vertical]. Each internal array are all the
# asteroids that share the same angle_to_vertical. Sort the array of arrays
# so that the ones with the smaller angle come first.
distances_by_angle = distances_to_others(best_coordinates, asteroids_map)
  .map { |distance| [distance, angle_to_vertical(distance)] }
  .group_by { |(_, angle)| angle }
  .values
  .sort_by { |distances_and_angles| distances_and_angles.first.last }

# Zip all arrays together (and flatten and compact that) so that we end up
# with an array of [distance_vector, angle_to_vertical] tuples which is like
# taking the first element of the array with the smallest angle, the first
# of the next smallest angle, and so on until we come back all the way around.
most_asteroids_in_a_row = distances_by_angle.map(&:size).max
zip_base = [nil] * most_asteroids_in_a_row
result = zip_base.zip(*distances_by_angle).flatten(1).compact.drop(199).first.first

# Convert the distance vector back to absolute coordinates
x = best_coordinates.x + result.x
y = best_coordinates.y + result.y

puts "Part 2: x=#{x} y=#{y} result=#{x * 100 + y}"
