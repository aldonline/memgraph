###
A simple library to create in memory graphs
instead of Vertex/Edge we use Node/Path terminology
to make it sound more RDF-ish
###

match = ( mask, v ) -> if mask? then mask is v else yes

class Triple
  constructor: ( @s, @p, @o ) ->
  matches: ( s, p, o ) -> match( s, @s ) and match( p, @p ) and match( o, @o )

exports.Graph = class Graph
  
  constructor: ( opts ) ->
    @o =
      # if not null we add methods to any node we manage
      ns: '_g_'
    @o[k] = v for own k, v of opts
    @triples = []
  
  insert: ( s, p, o ) ->
    throw 's must be defined' unless s?
    throw 'p must be defined' unless p?
    throw 'o must be defined' unless o?
    if @find_one s, p, o # redundant
      false
    else
      @triples.push t = new Triple s, p, o
      @_add_members s
      @_add_members o
      t
  
  _add_members: ( node ) ->
    if ( ns = @o.ns )?
      node[ ns + 'graph' ] = @
      # TODO: add more convenience methods if required
  
  remove: ( s_mask, p_mask, o_mask ) ->
    @triples = ( triple for triple in @triples when not triple.matches s_mask, p_mask, o_mask )

  find: ( s_mask, p_mask, o_mask ) ->
    triple for triple in @triples when triple.matches s_mask, p_mask, o_mask
  
  # less expensive than find. stops at first result
  find_one: ( s_mask, p_mask, o_mask ) ->
    for triple in @triples when triple.matches s_mask, p_mask, o_mask
      return triple 
    null
  
  size: -> @triples.length
  
  get_nodes: ->
    res = []
    for triple in @triples
      if -1 is res.indexOf triple.s
        res.push triple.s
      if -1 is res.indexOf triple.o
        res.push triple.o
    res
  
  @for_node: (node, ns = '_g_') ->
    if (g = node[ns + 'graph'])?
      g
    else
      new Graph ns:ns