require 'set'
require 'json'
require 'rgl/adjacency'
require 'rgl/dot'
require 'pry'

def scc(list)
  g = RGL::DirectedAdjacencyGraph.new
  # dg_rev = RGL::DirectedAdjacencyGraph.new
  dg = {}
  dg_rev = {}

  list.each do |e|
    u, v = e.split.map(&:to_i)
    dg[u] ||= Set.new
    dg_rev[v] ||= Set.new

    dg[u] << v
    dg_rev[v] << u

    g.add_edge(u, v)
  end

  g.write_to_graphic_file('jpg')

  @visited = Set.new
  @order = []
  @leaders = {}

  @depth = 0

  for node in dg_rev.keys.sort.reverse
    dfs(dg_rev, node)
  end

  @visited = Set.new
  @leaders = {}

  # for node in @order.keys.sort_by { |a,b| @order[a] <=> @order[b] }.reverse
  #   @leader = node
  #   dfs(dg, node)
  # end

  # puts @order.keys.sort_by { |a,b| @order[a] <=> @order[b] }.inspect

  # puts @leaders.inspect

  puts @order.inspect

  #   dfs(dg, node, node)
  # end

  # puts @order.inspect
end

def dfs(graph, node)
  return if @visited.include?(node)

  @visited << node

  @leaders[node] = @leader

  for nei in graph[node]
    dfs(graph, nei)
  end

  @depth += 1
  @order[node] = @depth
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
