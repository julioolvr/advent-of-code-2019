WIDTH = 25
HEIGHT = 6

image = ARGF.each_line.first.chomp.split('').map(&:to_i).each_slice(WIDTH * HEIGHT)
target_layer = image.min_by { |layer| layer.count(0) }
result = target_layer.count(1) * target_layer.count(2)
puts result
