Vector = Struct.new(:x, :y, :z) do
  def inspect
    "<x=#{x}, y=#{y}, z=#{z}>"
  end

  def +(other)
    Vector.new(x + other.x, y + other.y, z + other.z)
  end
end

class Moon
  attr_accessor :position, :velocity

  def initialize(initial_position)
    @position = initial_position
    @velocity = Vector.new(0, 0, 0)
  end

  def inspect
    "pos=#{position}, vel=#{@velocity}"
  end

  def apply_gravity(other_moon)
    Vector.members
      .reject { |axis| position[axis] == other_moon.position[axis] }
      .each do |axis|
        first_moon, second_moon = [self, other_moon].sort_by { |moon| moon.position[axis] }
        first_moon.velocity[axis] += 1
        second_moon.velocity[axis] -= 1
      end
  end

  def move
    self.position += velocity
  end

  def total_energy
    potential_energy * kinetic_energy
  end

  private

    def potential_energy
      position.x.abs + position.y.abs + position.z.abs
    end

    def kinetic_energy
      velocity.x.abs + velocity.y.abs + velocity.z.abs
    end
end

LINE_FORMAT = /x=(-?\d+).*y=(-?\d+).*z=(-?\d+)/

input_file = ARGF.each_line.map(&:chomp)

def build_moons(input_file)
  input_file.map do |line|
    x, y, z = line.match(LINE_FORMAT).captures.map(&:to_i)
    Moon.new(Vector.new(x, y, z))
  end
end

moons = build_moons(input_file)

def apply_gravity(moons)
  moons.each_with_index do |moon, i|
    moons.drop(i + 1).each do |other_moon|
      moon.apply_gravity(other_moon)
    end
  end
end

1000.times do |i|
  apply_gravity(moons)
  moons.each(&:move)
end

puts "Part 1: #{moons.sum(&:total_energy)}"

moons = build_moons(input_file)
starting_x = moons.map { |moon| [moon.position.x, moon.velocity.x] }
period_x = 0

loop do
  period_x += 1
  apply_gravity(moons)
  moons.each(&:move)
  break if starting_x == moons.map { |moon| [moon.position.x, moon.velocity.x] }
end

moons = build_moons(input_file)
starting_y = moons.map { |moon| [moon.position.y, moon.velocity.y] }
period_y = 0

loop do
  period_y += 1
  apply_gravity(moons)
  moons.each(&:move)
  break if starting_y == moons.map { |moon| [moon.position.y, moon.velocity.y] }
end

moons = build_moons(input_file)
starting_z = moons.map { |moon| [moon.position.z, moon.velocity.z] }
period_z = 0

loop do
  period_z += 1
  apply_gravity(moons)
  moons.each(&:move)
  break if starting_z == moons.map { |moon| [moon.position.z, moon.velocity.z] }
end

puts "Part 2: #{[period_x, period_y, period_z].reduce(1, :lcm)}"
