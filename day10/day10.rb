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
end

HORIZONTAL = Vector.new(1, 0)

def visible_asteroids_from(x, y, asteroids_map)
  distances_to_others(x, y, asteroids_map)
    .map do |distance|
      angle = distance.angle(HORIZONTAL)
      angle = 2 * Math::PI - angle if distance[1].negative?
      angle
    end
    .uniq { |angle| angle.round(10) } # Rounding to avoid precision errors, there has to be a better
                                      # way to handle this...
end

def distances_to_others(x, y, asteroids_map)
  height = asteroids_map.size
  width = asteroids_map.first.size

  all_asteroids(asteroids_map)
    .map { |(other_x, other_y)| Vector.new(other_x - x, other_y - y) }
    .sort_by(&:length)
    .drop(1)
end

def all_asteroids(asteroids_map)
  height = asteroids_map.size
  width = asteroids_map.first.size

  (0...width).to_a.product((0...height).to_a)
    .select { |(x, y)| asteroids_map[y][x] }
end

result = all_asteroids(asteroids_map)
  .map { |(x, y)| visible_asteroids_from(x, y, asteroids_map).count }
  .max

puts result
