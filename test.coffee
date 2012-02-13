assert = require 'assert'
memgraph = require './memgraph'

console.log 'tests start'

Graph = memgraph.Graph

class Thing
  constructor: ( @id ) ->
  toString: -> @id


graph = new Graph

# entities
aldo = new Thing 'aldo'
bob = new Thing 'bob'
tech = new Thing 'tech'
music = new Thing 'music'

# properties
friend = new Thing 'friend'
hobby = new Thing 'hobby'

assert.equal graph.size(), 0, 'graph must be empty'

graph.insert aldo, friend, bob
assert.equal graph.size(), 1, 'graph must have one triple now'
assert.equal aldo._g_graph, graph, 'reference to graph must now exist on objects'

graph.insert aldo, hobby, tech
graph.insert bob, hobby, music
assert.equal graph.size(), 3, 'graph must have three triples now'

# add repeated triple, nothing should change
graph.insert bob, hobby, music
assert.equal graph.size(), 3, 'graph must have three triples now'

assert.equal graph.find( aldo, null, null ).length, 2, 'aldo exists in two triples'

# there are 4 different nodes in the graph
assert.equal graph.get_nodes().length, 4

console.log 'tests end'