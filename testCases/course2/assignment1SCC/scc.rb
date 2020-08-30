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

  graph.write_to_graphic_file('jpg')

  @visited = Set.new
  @stack = []
  @leaders = {}

  for node in graph.vertices.sort.reverse
    dfs(graph.reverse, node)
  end

  @visited = Set.new
  @leaders = {}

  while !@stack.empty?
    @leader = @stack.pop
    dfs(graph, @leader)
  end

  return @leaders.keys.map { |k| @leaders[k].size }.sort.reverse
end

def dfs(graph, node)
  return if @visited.include?(node)

  @visited << node

  @leaders[@leader] ||= Set.new
  @leaders[@leader] << node

  for nei in graph.adjacent_vertices(node)
    dfs(graph, nei)
  end

  @stack << node
end

require "minitest/autorun"

describe 'scc' do
  specify do
    assert_equal -1, scc(File.read('SCC.txt').split("\n"))
  end

  specify do
    # TODO this does need to amand two zeros to the end, but that's OK for now
    assert_equal [4,2,2], scc(File.read('input_mostlyCycles_1_8.txt').split("\n"))
  end
end
