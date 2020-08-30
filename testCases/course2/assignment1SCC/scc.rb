require 'set'
require 'json'
require 'rgl/adjacency'
require 'rgl/dot'
require 'pry'

def scc(list)
  graph = RGL::DirectedAdjacencyGraph.new
  # dg_rev = RGL::DirectedAdjacencyGraph.new
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

  @visited = Set.new
  @stack = []
  @leaders = {}

  reversed = graph.reverse

  for node in graph.vertices.sort.reverse
    @leader = node  
    @leaders[@leader] = 0

    dfs(reversed, node)
  end

  @visited = Set.new
  @leaders = {}

  while !@stack.empty?
    @leader = @stack.pop
    @leaders[@leader] ||= 0

    dfs(graph, @leader)
  end

  return @leaders.values.sort.reverse[0..4]
end

def dfs(graph, node)
  return if @visited.include?(node)

  @visited << node

  @leaders[@leader] += 1

  for nei in graph.adjacent_vertices(node)
    next if @visited.include?(nei)
    dfs(graph, nei)
  end

  @stack << node
end

require "minitest/autorun"

describe 'scc' do
  # specify do
  #   assert_equal -1, scc(File.read('SCC.txt').split("\n"))
  # end

  specify do
    assert_equal [4,2,2,0,0], scc(File.read('input_mostlyCycles_1_8.txt').split("\n"))
  end

  specify do
    assert_equal [11,10,5,4,1], scc(File.read('input_mostlyCycles_10_32.txt').split("\n"))
  end
end
