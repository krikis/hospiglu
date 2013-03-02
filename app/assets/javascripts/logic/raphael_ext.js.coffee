Raphael.fn.dragger = ->
  @ox = (if @type is "rect" then @attr("x") else @attr("cx"))
  @oy = (if @type is "rect" then @attr("y") else @attr("cy"))
  @shapeProperties = @model.get('properties')
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
  @shapeProperties.x = @ox + dx
  @shapeProperties.y = @oy + dy
  @attr att
  Hospiglu.connectionsCallbacks.add =>
    _.each @model.outgoingConnections(), (connection) =>
      @paper.connection connection.el
    _.each @model.incomingConnections(), (connection) =>
      @paper.connection connection.el
  @paper.safari()

Raphael.fn.up = ->
  @model.save(properties: @shapeProperties)
  @animate
      "fill-opacity": 0
    , 500