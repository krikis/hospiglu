Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    dragger: ->
      @ox = (if @type is "rect" then @attr("x") else @attr("cx"))
      @oy = (if @type is "rect" then @attr("y") else @attr("cy"))
      @animate
        "fill-opacity": .2
      , 500

    move: (dx, dy) ->
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

    up: ->
      @animate
          "fill-opacity": 0
        , 500

    render: ->
      paper = @options.paper
      if paper.isMenu? == @model.get('menu_id')?
        shapeProperties = @model.get('properties')
        @shape = paper[shapeProperties.shape_type].call(
          paper,
          shapeProperties.x,
          shapeProperties.y,
          shapeProperties.width,
          shapeProperties.height,
          shapeProperties.border_radius
        )
        @shape.model = @model
        @model.el = @shape
        color = Raphael.getColor()
        @shape.attr
          fill: color
          stroke: color
          'fill-opacity': 0
          'stroke-width': 2
          cursor: 'move'
        @shape.drag(@move, @dragger, @up) unless paper.isMenu?
        @

    onClose: ->
      @shape?.remove()
