class Orbiter
  attr_accessor :name

  def initialize(name)
    @name = name
    @orbiting = []
  end

  def add_orbit(other)
    @orbiting << other
  end

  def count_of_orbits
    @count_of_orbits ||= @orbiting.map(&:count_of_orbits).sum + @orbiting.size
  end
end

bodies = {}

ARGF.each_line do |line|
  target_name, body_name = line.split(')').map(&:chomp)
  target = bodies[target_name] || (bodies[target_name] = Orbiter.new(target_name))
  body = bodies[body_name] || (bodies[body_name] = Orbiter.new(body_name))
  body.add_orbit(target)
end

result = bodies.values.map(&:count_of_orbits).sum
puts "Part 1: #{result}"
