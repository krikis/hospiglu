Raphael.fn.dragger = ->
  @ox = (if @type is "rect" then @attr("x") else @attr("cx"))
  @oy = (if @type is "rect" then @attr("y") else @attr("cy"))
  @animate
    "fill-opacity": .2
  , 500

Raphael.fn.move = (dx, dy) ->
  att = (if @type is "rect"
    x: @ox + dx
    y: @oy + dy
   else
    cx: @ox + dx
    cy: @oy + dy
  )
  @attr att
  Hospiglu.connectionsCallbacks.add =>
    _.each @model.outgoingConnections(), (connection) =>
      @paper.connection connection.el
    _.each @model.incomingConnections(), (connection) =>
      @paper.connection connection.el
  @paper.safari()

Raphael.fn.up = ->
  @animate
      "fill-opacity": 0
    , 500