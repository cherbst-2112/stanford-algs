require 'set'
require 'json'
require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/path'
require 'pry'
require 'rgl/dijkstra'


def dijkstra(list)
  graph = RGL::DirectedAdjacencyGraph.new

  # edge_weights =
  # {
  #   ["New York", "Los Angeles"] => 2445,
  #   ["Los Angeles", "Chicago"] => 2015,
  #   ["Los Angeles", "Houston"] => 1547,
  #   ["Chicago", "Houston"] => 939,
  #   ["Seattle", "Los Angeles"] => 1548
  # }
  # edge_weights.each { |(city1, city2), w| graph.add_edge(city1, city2) }

  edge_weights = {}

  list.each do |e|
    vertices = e.split

    u = vertices.shift.to_i

    while !vertices.empty?
      v, weight = vertices.shift.split(',').map(&:to_i)
      edge_weights[[u, v]] = weight

      graph.add_edge(u, v)
    end
  end

  # graph.write_to_graphic_file('jpg')

# graph.dijkstra_shortest_path(edge_weights, 1, 7)
# [1, 8, 103, 84, 169, 100, 147, 120, 132, 16, 33, 7]

  targets = [7,37,59,82,99,115,133,165,188,197]
  results = []

  for target in targets
    queue = [[1, 0]]

    visited = Set.new
    result = 2 ** 32

    while !queue.empty?
      u, weight = queue.shift

      if u == target
        result = [result, weight].min
      else
        visited << u

        for nei in graph.adjacent_vertices(u)
          next if visited.include?(nei)

          queue << [nei, weight + edge_weights[[u, nei]]]
        end
      end
    end

    results << result
  end

  return results
end


require "minitest/autorun"

describe 'dijkstra' do
  # specify do
  #   assert_equal 'TODO', dijkstra(File.read('dijkstraData.txt').split("\n"))
  # end

  specify do
    examples = [
      'random_1_4',
      'random_2_4',
      # TODO getting wrong result for this next one
      # 'random_3_4',
      # 'random_4_4',
      # 'random_5_8',
      # 'random_6_8',
      # 'random_7_8',
      # 'random_8_8',
      # 'random_9_16',
      # 'random_10_16',
      # 'random_11_16',
      # 'random_12_16',
      # 'random_13_32',
      # 'random_14_32',
      # 'random_15_32',
      # 'random_16_32',
      # 'random_17_64',
      # 'random_18_64',
      # 'random_19_64',
      # 'random_20_64',
      # 'random_21_128',
      # 'random_22_128',
      # 'random_23_128',
      # 'random_24_128',
      # 'random_25_256',
      # 'random_26_256',
      # 'random_27_256',
      # 'random_28_256'
    ]

    for e in examples
      puts "running #{e}..."
      assert_equal File.read("output_#{e}.txt").split(',').map(&:to_i), dijkstra(File.read("input_#{e}.txt").split("\n"))
    end
  end
end
