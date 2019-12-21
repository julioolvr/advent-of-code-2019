Node = Struct.new(:type) do
  attr_accessor :batch_size
  attr_reader :stock

  def initialize(*args)
    super(*args)
    @stock = 0
  end

  def build(quantity)
    @stock += batch_size * quantity
  end

  def take_stock(max)
    if max >= stock
      used_stock = stock
      @stock = 0
    else
      used_stock = max
      @stock -= max
    end

    used_stock
  end
end

Edge = Struct.new(:from, :to, :weight)

class Graph
  attr_accessor :nodes

  def initialize
    @nodes = {}
    @edges = []
  end

  def attach(from_type, to_type, from_quantity, to_quantity)
    node_from = get_or_create_node(from_type)
    node_to = get_or_create_node(to_type, to_quantity)
    @edges << Edge.new(from_type, to_type, from_quantity)
  end

  def build_type(type, quantity = 1)
    return quantity if type == 'ORE'

    node = @nodes[type]
    stock_used = node.take_stock(quantity)
    missing = quantity - stock_used

    return 0 if missing == 0

    batches_to_build = (missing / node.batch_size.to_f).ceil

    ore_needed = edges_to(type).sum do |edge|
      batches_to_build.times.sum { build_type(edge.from, edge.weight) }
    end

    node.build(batches_to_build)
    node.take_stock(missing)

    ore_needed
  end

  private

    def get_or_create_node(type, batch_size = nil)
      node = @nodes[type] || Node.new(type)
      node.batch_size = batch_size unless batch_size.nil?
      @nodes[type] = node
      node
    end

    def edges_to(type)
      @edges.select { |edge| edge.to == type }
    end
end

graph = Graph.new

ARGF.each_line.map(&:chomp).map do |line|
  from, to = line.split('=>').map(&:strip)
  to_quantity, to_type = to.split

  from
    .split(',')
    .map(&:strip)
    .map(&:split)
    .each do |(from_quantity, from_type)|
      graph.attach(from_type, to_type, from_quantity.to_i, to_quantity.to_i)
    end
end

puts graph.build_type('FUEL')
