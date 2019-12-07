class Orbiter
  def initialize
    @orbiting = nil
    @orbiters = []
  end

  def set_orbit(other)
    @orbiting = other
    other.add_orbiter(self)
  end

  def add_orbiter(other)
    @orbiters << other
  end

  def count_of_orbits
    if @orbiting
      @orbiting.count_of_orbits + 1
    else
      0
    end
  end

  def possible_transfers
    @orbiters + [@orbiting].compact
  end
end

bodies = {}

ARGF.each_line do |line|
  target_name, body_name = line.split(')').map(&:chomp)
  target = bodies[target_name] || (bodies[target_name] = Orbiter.new)
  body = bodies[body_name] || (bodies[body_name] = Orbiter.new)
  body.set_orbit(target)
end

result = bodies.values.map(&:count_of_orbits).sum
puts "Part 1: #{result}"

from = bodies['YOU']
to = bodies['SAN']

steps = 0
frontier = from.possible_transfers
visited = frontier

until frontier.include?(to)
  frontier = frontier.flat_map(&:possible_transfers) - visited
  visited += frontier
  steps += 1
end

puts "Part 2: #{steps - 1}"
