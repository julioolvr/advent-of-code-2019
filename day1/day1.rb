puts ARGF.each_line.map { |n| n.to_i / 3 - 2 }.sum
