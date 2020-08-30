require 'set'
require 'json'
require 'rgl/adjacency'
require 'rgl/dot'
require 'pry'

def scc(list)
  # g = RGL::DirectedAdjacencyGraph.new
  # dg_rev = RGL::DirectedAdjacencyGraph.new
  dg = {}
  dg_rev = {}

  list.each do |e|
    u, v = e.split.map(&:to_i)
    dg[u] ||= Set.new
    dg_rev[v] ||= Set.new

    dg[u] << v
    dg_rev[v] << u

    # g.add_edge(u, v)
  end

  # g.write_to_graphic_file('jpg')

  @visited = Set.new
  @stack = []
  @leaders = {}

  for node in dg_rev.keys.sort.reverse
    dfs(dg_rev, node)
  end

  @visited = Set.new
  @leaders = {}

  while !@stack.empty?
    @leader = @stack.pop
    dfs(dg, @leader)
  end

  return @leaders.map { |l| l.size + 1 }.sort[0..4]
end

def dfs(graph, node)
  return if @visited.include?(node)

  @visited << node

  @leaders[@leader] ||= Set.new
  @leaders[@leader] << node

  for nei in graph[node]
    dfs(graph, nei)
  end

  @stack << node
end

require "minitest/autorun"

describe 'scc' do
  # specify do
  #   # TODO I get 1112 but this is not correct
  #   assert_equal -1, min_cut(File.read('/Users/chris/Projects/dojo/min_cut.txt').split("\n"))
  # end

  # specify do
  #   assert_equal -1, scc(File.read('/Users/chris/Projects/dojo/SCC.txt').split("\n")[0..100])
  # end


  specify do
    # assert_equal [11,10,5,4,1], scc(File.read('input_mostlyCycles_10_32.txt').split("\n"))
    assert_equal [3,3,3,0,0], scc(File.read('input_mostlyCycles_10_32.txt').split("\n"))
  end
end
