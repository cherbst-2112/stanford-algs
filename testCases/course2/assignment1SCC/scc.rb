require 'set'
require 'json'
require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/connected_components'
require 'pry'

def scc(list)
  graph = RGL::DirectedAdjacencyGraph.new
  # dg = {}
  # dg_rev = {}

  list.each do |e|
    u, v = e.split.map(&:to_i)
    # dg[u] ||= Set.new
    # dg[v] ||= Set.new
    # dg_rev[u] ||= Set.new
    # dg_rev[v] ||= Set.new

    # dg[u] << v
    # dg_rev[v] << u

    graph.add_edge(u, v)
  end

  # graph.write_to_graphic_file('jpg')

  # # # this does it with the rgl lib, but does not work with large inputs
  # components = {}

  # graph.strongly_connected_components.comp_map.each_pair do |node, component|
  #   components[component] ||= 0
  #   components[component] += 1
  # end

  # result = components.values.sort.reverse[0..4]

  # while result.length < 5
  #   result << 0
  # end

  # return result

  stack = []
  order = []
  visited = Set.new

  for node in (1..graph.vertices.max)
    next if visited.include?(node)

    stack << node
    visited << node

    while !stack.empty?
      s = stack.pop

      if !visited.include?(s)
        order << s
        visited << s
      end

      # TODO not sure why this is using the forward version of the graph, but OK
      if graph.vertices.include?(s)
        for nei in graph.adjacent_vertices(s)
          if !visited.include?(nei)
            stack << nei
          end
        end
      else
        # if we do not have any vertices, this is an isolated node and still needs to come up in the order
        order << s
      end
    end
  end

  visited = Set.new
  stack = []
  t = 0
  scc = Hash.new(0)

  graph_reverse = graph.reverse

  while !order.empty?
    i = order.pop
    # puts [__LINE__, i].inspect

    stack << i

    while !stack.empty?
      s = stack.pop

      next if visited.include?(s)

      visited << s
      t += 1

      if graph.vertices.include?(s)
        for nei in graph_reverse.adjacent_vertices(s)
          stack << nei unless visited.include?(nei)
        end
      end
    end

    scc[i] = t
    t = 0
  end

  return scc.values.sort.reverse[0..4]
end

def dfs(graph, node)
  return if @visited.include?(node)

  @visited << node

  @leaders[@leader] += 1

  for nei in graph[node]
    next if @visited.include?(nei)
    dfs(graph, nei)
  end

  @stack << node
end

require "minitest/autorun"

describe 'scc' do
  # specify do
  #   # TODO we get [533586, 1036, 618, 480, 404] like the python, but this is not correct
  #   assert_equal -1, scc(File.read('SCC.txt').split("\n"))
  # end

  specify do
    examples = [
      'base_case',
      'mostlyCycles_10_32', 
      'mostlyCycles_11_32', 
      'mostlyCycles_12_32', 
      'mostlyCycles_13_64', 
      'mostlyCycles_14_64', 
      'mostlyCycles_15_64', 
      'mostlyCycles_16_64', 
      'mostlyCycles_17_128', 
      'mostlyCycles_18_128', 
      'mostlyCycles_19_128', 
      'mostlyCycles_1_8', 
      'mostlyCycles_20_128', 
      'mostlyCycles_21_200', 
      'mostlyCycles_22_200', 
      'mostlyCycles_23_200', 
      'mostlyCycles_24_200', 
      'mostlyCycles_25_400', 
      'mostlyCycles_26_400', 
      'mostlyCycles_27_400', 
      'mostlyCycles_28_400', 
      'mostlyCycles_29_800', 
      'mostlyCycles_2_8', 
      'mostlyCycles_30_800', 
      'mostlyCycles_31_800', 
      'mostlyCycles_32_800', 
      'mostlyCycles_33_1600', 
      'mostlyCycles_34_1600', 
      'mostlyCycles_35_1600', 
      'mostlyCycles_36_1600', 
      'mostlyCycles_37_3200', 
      'mostlyCycles_38_3200', 
      'mostlyCycles_39_3200', 
      'mostlyCycles_3_8', 
      'mostlyCycles_40_3200', 
      'mostlyCycles_41_6400', 
      'mostlyCycles_42_6400', 
      'mostlyCycles_43_6400', 
      'mostlyCycles_44_6400', 
      'mostlyCycles_45_12800', 
      'mostlyCycles_46_12800', 
      'mostlyCycles_47_12800', 
      'mostlyCycles_48_12800', 
      'mostlyCycles_49_20000', 
      'mostlyCycles_4_8', 
      'mostlyCycles_50_20000', 
      'mostlyCycles_51_20000', 
      'mostlyCycles_52_20000', 
      'mostlyCycles_53_40000', 
      'mostlyCycles_54_40000', 
      'mostlyCycles_55_40000', 
      'mostlyCycles_56_40000', 
      'mostlyCycles_57_80000', 
      'mostlyCycles_58_80000', 
      'mostlyCycles_59_80000', 
      'mostlyCycles_5_16', 
      'mostlyCycles_60_80000', 
      'mostlyCycles_61_160000', 
      'mostlyCycles_62_160000', 
      'mostlyCycles_63_160000', 
      'mostlyCycles_64_160000', 
      'mostlyCycles_65_320000', 
      'mostlyCycles_66_320000', 
      'mostlyCycles_67_320000', 
      'mostlyCycles_68_320000', 
      'mostlyCycles_6_16', 
      'mostlyCycles_7_16', 
      'mostlyCycles_8_16', 
      'mostlyCycles_9_32'
    ]

    for e in examples
      puts "running #{e}..."
      assert_equal File.read("output_#{e}.txt").split(',').map(&:to_i), scc(File.read("input_#{e}.txt").split("\n"))
    end
  end
end
