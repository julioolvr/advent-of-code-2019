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
    [:x, :y, :z].each do |axis|
      if position[axis] != other_moon.position[axis]
        first_moon, second_moon = [self, other_moon].sort_by { |moon| moon.position[axis] }
        first_moon.velocity[axis] += 1
        second_moon.velocity[axis] -= 1
      end
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

moons = ARGF.each_line.map(&:chomp).map do |line|
  x, y, z = line.match(LINE_FORMAT).captures.map(&:to_i)
  Moon.new(Vector.new(x, y, z))
end

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

puts moons.sum(&:total_energy)
