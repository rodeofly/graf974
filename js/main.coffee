unique_id = 0
graph = {}
foo_graph = ->
  graph =
    "nodes": []
    "links": []
  for i in [0..10]
    graph.nodes.push {"id": ++unique_id,"x": 12, "y": 10}
  for i in [3..5]
    graph.links.push( {"source": unique_id+i-10, "target": unique_id+i-9, "weight": i} )
  
chess_graph = (n = 8) ->
  graph =
    "nodes": []
    "links": []

  for l in [n..1]
    for c in [n..1]
      graph.nodes.push {"x": 0, "y": 0, "l": l, "c": c}
  
  for l in [0..n-2]
    for c in [0..n-2]
        graph.links.push( {"source": n*l+c, "target": n*l+(c+1), "weight": 23} )
        graph.links.push( {"source": n*l+c, "target": n*(l+1)+c, "weight": 23} )
  
  for i in [0..n-2]
    graph.links.push( {"source": n*(n-1)+i, "target": n*(n-1)+(i+1), "weight": 23} )
    graph.links.push( {"source": n*i+n-1, "target": n*(i+1)+n-1, "weight": 23} )

snake_graph = (n = 8) ->
  graph =
    "nodes": []
    "links": []

  for i in [1..n]
    graph.nodes.push {"x": 0, "y": 0, "l": i}
  
  for i in [0..n-2]
    graph.links.push( {"source": i, "target": i+1, "weight": 23} )
 
  
class NoutGraf
  constructor: (JSgraph, @width = 1024, @height = 1024) ->
    @id = ++unique_id
    refresh = ->
      link
        .attr("x1", (d) -> return d.source.x)
        .attr("y1", (d) -> return d.source.y)
        .attr("x2", (d) -> return d.target.x)
        .attr("y2", (d) -> return d.target.y)
      node
        .attr("cx", (d) -> return d.x)
        .attr("cy", (d) -> return d.y)
    
    @force = d3.layout.force()
      .size [@width, @height]
      .charge -400
      .linkDistance 40
      .on "tick", -> refresh()

    dblclick = (d) -> d3.select(this).classed "fixed", d.fixed = false
    dragstart = (d) -> d3.select(this).classed "fixed", d.fixed = true
    drag = @force.drag().on "dragstart", -> dragstart
      
    container = svg.append "g"
      .attr "class", "noutgraf"
       
    link = container.selectAll(".link")
    node = container.selectAll(".node")
    
    @addNode = (JSgraph) ->
      @force
        .nodes(JSgraph.nodes)
        .links(JSgraph.links)
        .start()

      link = link.data(JSgraph.links).enter().append "line"
        .attr("class", "link")

      node = node.data(JSgraph.nodes).enter().append "circle"
        .text "##{@id}"
        .attr "class", "node"
        .attr "r", 12
        .attr("l", (d) -> return d.l)
        .attr("c", (d) -> return d.c)
        .on "click", ->
          console.log "l:#{d3.select(this).attr 'l'} ; c:#{d3.select(this).attr 'c'}"           
        .call drag
      
    
svg = d3.select("#svg")
  .attr("width", 1024)
  .attr("height", 600)  
g = new NoutGraf()
snake_graph(8)
g.addNode graph
h = new NoutGraf()
chess_graph(8)
h.addNode graph





