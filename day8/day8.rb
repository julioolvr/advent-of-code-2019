WIDTH = 25
HEIGHT = 6

image = ARGF.each_line.first.chomp.split('').map(&:to_i).each_slice(WIDTH * HEIGHT)
target_layer = image.min_by { |layer| layer.count(0) }
result = target_layer.count(1) * target_layer.count(2)
puts "Part 1: #{result}"

BLACK = 0
TRANSPARENT = 2

decoded_image = image.first.map.with_index do |_, i|
  image.lazy.map { |layer| layer[i] }.find { |pixel| pixel != TRANSPARENT }
end

puts "Part 2:"
decoded_image.each_slice(WIDTH) do |line|
  puts line.map { |pixel| pixel == BLACK ? "\u25FE" : "\u25FD" }.join('')
end
